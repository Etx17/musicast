class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
    @user.build_jury
    super
  end

  def create
    # Ta logique originale pour vérifier un candidat existant
    existing_user_check = User.find_by_email(params["user"]["email"])
    if existing_user_check && existing_user_check.candidat && params["user"]["inscription_role"] == "candidate"
      category_id = params.dig("user", "category_id")
      unless category_id.present?
        flash[:alert] = "L'ID de la catégorie est manquant pour l'invitation du candidat."
        redirect_back(fallback_location: root_path) and return
      end
      category = Category.find(category_id)
      existing_inscription = Inscription.find_by(candidat: existing_user_check.candidat, category: category)

      if existing_inscription
        existing_inscription.update(is_late_inscription: true)
      else
        Inscription.create(is_late_inscription: true, candidat: existing_user_check.candidat, category: category, terms_accepted: true)
      end
      flash[:notice] = "Candidat déjà inscrit, inscription mise à jour."
      redirect_back(fallback_location: root_path) and return
    end

    # Préparer les paramètres pour l'invitation de l'utilisateur (sans les attributs imbriqués pour l'instant)
    user_invite_params = invite_params.except(:jury_attributes, :candidat_attributes)

    # Inviter l'utilisateur. User.invite! s'occupe de la création/ré-invitation et de l'envoi de l'email.
    self.resource = User.invite!(user_invite_params, current_inviter) # current_inviter est optionnel mais bon à passer

    if resource.errors.empty? && resource.persisted?
      # L'utilisateur a été invité avec succès et l'email envoyé.
      # Maintenant, gérons les associations (Jury ou Candidat).

      case resource.inscription_role
      when "jury"
        jury_attributes = invite_params[:jury_attributes]
        if jury_attributes.present?
          target_jury = resource.jury || resource.build_jury # Trouve ou construit le jury
          target_jury.assign_attributes(jury_attributes.merge(email: resource.email)) # Assigne les attributs et l'email

          unless target_jury.save
            # La sauvegarde du jury a échoué, ajouter les erreurs au 'resource' (User)
            target_jury.errors.full_messages.each { |msg| resource.errors.add(:base, "Jury: #{msg}") }
          else
            # Le jury est sauvegardé, créer l'association OrganismJury
            if current_user&.organisateur&.organism.present?
              OrganismJury.find_or_create_by(organism: current_user.organisateur.organism, jury: target_jury)
            end
          end
        end
      when "candidate"
        candidat_attributes = invite_params[:candidat_attributes]
        if candidat_attributes.present?
          target_candidat = resource.candidat || resource.build_candidat
          target_candidat.assign_attributes(candidat_attributes) # Pas d'email à merger ici habituellement

          unless target_candidat.save
            target_candidat.errors.full_messages.each { |msg| resource.errors.add(:base, "Candidat: #{msg}") }
          else
            # Candidat sauvegardé, créer l'inscription
            category_id_for_inscription = params.dig("user", "category_id")
            if category_id_for_inscription.present?
              category = Category.find(category_id_for_inscription)
              Inscription.find_or_create_by(candidat: target_candidat, category: category) do |inscription|
                inscription.is_late_inscription = true
                inscription.terms_accepted = true # S'assurer que terms_accepted est bien géré
              end
            else
              resource.errors.add(:base, "Candidate: Category ID is missing for inscription.")
            end
          end
        end
      end

      # Vérifier à nouveau les erreurs après la gestion des associations
      if resource.errors.empty?
        set_flash_message :notice, :send_instructions, email: resource.email if is_flashing_format?
        # Redirection originale commentée : redirect_back(fallback_location: root_path)
        # Utiliser la redirection standard de Devise ou ta redirection personnalisée
        respond_with resource, location: after_invite_path_for(current_inviter || resource)
      else
        # Des erreurs ont été ajoutées lors de la sauvegarde du jury/candidat
        # `respond_with resource` rendra la vue `new` avec les erreurs accumulées
        respond_with resource
      end
    else
      # Erreurs lors de User.invite! (ex: email invalide)
      # `respond_with resource` rendra la vue `new` avec les erreurs
      respond_with resource
    end
  end

  def update
    super
  end


  protected

  def configure_permitted_parameters
    super
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :inscription_role, jury_attributes: [:first_name, :last_name, :avatar], candidat_attributes: [:first_name, :last_name]])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:email, :inscription_role, jury_attributes: [:first_name, :last_name, :avatar], candidat_attributes: [:first_name, :last_name]])
  end

  def jury_params
    params.require(:user).permit(:inscription_role, :email, jury_attributes: [:first_name, :last_name, :short_bio, :email, :avatar])
  end

  def candidat_params
    params.require(:user).permit(:inscription_role, :email, candidat_attributes: [:first_name, :last_name, :avatar])
  end


  def after_invite_path_for(resource)
    request.referrer
  end

end
