class InscriptionStepsController < ApplicationController
  include Wicked::Wizard

  steps :program, :item_requirements, :preferences
  before_action :set_inscription

  # Action pour télécharger une image immédiatement
  def upload_item_image
    @inscription = Inscription.find(params[:inscription_id])
    authorize @inscription if defined?(Pundit)

    if params[:item_id].present? && params[:image].present?
      item_requirement = @inscription.inscription_item_requirements.find(params[:item_id])

      # Vérifier les métadonnées de l'image avant l'attachement
      if params[:image].tempfile.present?
        # Extraire les métadonnées
        metadata = ImageMetadataService.get_complete_metadata(params[:image].tempfile.path)

        if metadata
          Rails.logger.info "Métadonnées de l'image: #{metadata.inspect}"

          # Vous pouvez vérifier le DPI ici et décider si vous voulez continuer
          if metadata[:resolution].present?
            dpi_x = metadata[:resolution][0]
            dpi_y = metadata[:resolution][1]

            # Stocker le DPI dans un attribut, si vous souhaitez le conserver
            item_requirement.dpi_x = dpi_x
            item_requirement.dpi_y = dpi_y

            # Exemple: Vérifier si le DPI est suffisant (par exemple, au moins 300 DPI)
            min_dpi = 72 # Valeur minimale courante pour le web
            if dpi_x < min_dpi || dpi_y < min_dpi
              Rails.logger.warn "DPI trop bas: #{dpi_x} x #{dpi_y}"
              # Vous pouvez décider de continuer ou d'annuler l'upload
              # return render json: { success: false, message: "Résolution d'image trop basse (#{dpi_x} DPI). Minimum requis: #{min_dpi} DPI" }, status: :unprocessable_entity
            end
          end
        end
      end

      item_requirement.submitted_file.purge if item_requirement.submitted_file.attached?

      item_requirement.submitted_file.attach(params[:image])

      # S'assurer que les valeurs DPI sont enregistrées APRÈS avoir attaché le fichier
      # et AVANT de sauvegarder l'enregistrement
      if metadata && metadata[:resolution].present?
        item_requirement.dpi_x = metadata[:resolution][0]
        item_requirement.dpi_y = metadata[:resolution][1]

        # Ajouter les métadonnées complètes dans un attribut metadata
        item_requirement.metadata = metadata if item_requirement.respond_to?(:metadata=)
      end

      # S'assurer que l'enregistrement est sauvegardé avec force
      item_requirement.save!

      if item_requirement.submitted_file.attached?
        item_requirement.reload
        begin
          image_url = url_for(item_requirement.submitted_file)

          render json: {
            success: true,
            message: "Image téléchargée avec succès",
            image_url: image_url,
            metadata: metadata
          }
        rescue => e
          Rails.logger.error "Erreur lors de la génération de l'URL: #{e.message}"

          blob = item_requirement.submitted_file.blob
          alt_url = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)

          render json: {
            success: true,
            message: "Image téléchargée avec succès (URL alternative)",
            image_url: alt_url,
            metadata: metadata
          }
        end
      else
        render json: {
          success: false,
          message: "Impossible d'attacher l'image"
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: "Paramètres manquants"
      }, status: :bad_request
    end
  rescue => e
    Rails.logger.error "Erreur lors du téléchargement de l'image: #{e.message}"
    render json: {
      success: false,
      message: "Une erreur s'est produite: #{e.message}"
    }, status: :internal_server_error
  end

  def purge_item_image
    @inscription = Inscription.find(params[:inscription_id])
    authorize @inscription if defined?(Pundit)

    if params[:item_id].present?
      item_requirement = @inscription.inscription_item_requirements.find(params[:item_id])

      if item_requirement.submitted_file.attached?
        item_requirement.submitted_file.purge
        flash[:notice] = "Image supprimée avec succès"
      else
        flash[:alert] = "Aucune image à supprimer"
      end
    else
      flash[:alert] = "Paramètre manquant"
    end

    redirect_to wizard_path(:item_requirements, action: "edit")
  rescue => e
    Rails.logger.error "Erreur lors de la suppression de l'image: #{e.message}"
    flash[:alert] = "Une erreur s'est produite: #{e.message}"
    redirect_to wizard_path(:item_requirements, action: "edit")
  end

  def edit
    case step
    when :program
    when :item_requirements
      if @inscription.inscription_item_requirements.none?
        @inscription.category.requirement_items.each do |item|
          @inscription.inscription_item_requirements.new(requirement_item: item)
        end
        @inscription.save(validate: false)
      end
    when :preferences
    end
    render_wizard
  end

  def update
    # Contourner les problèmes avec ActiveStorage::Attached::One
    adjusted_params = adjust_params_for_files(inscription_params)
    @inscription.assign_attributes(adjusted_params)
    case step
    when :program
      if @inscription.valid?(:program)
        @inscription.save
        redirect_to wizard_path(:item_requirements, action: "edit")
      else
        render 'program', status: :unprocessable_entity
      end
    when :item_requirements
      if @inscription.valid?(:item_requirements)
        @inscription.save
        redirect_to wizard_path(:preferences, action: "edit")
      else
        render 'item_requirements', status: :unprocessable_entity
      end
    when :preferences
      if params[:inscription][:payment_proof].present?
        @inscription.payment_proof.purge if @inscription.payment_proof.attached?
        @inscription.payment_proof.attach(params[:inscription][:payment_proof])
      end

      if @inscription.valid?(:preferences)
        if @inscription.is_ready_to_be_reviewed? && (@inscription.status == "draft" || @inscription.status == "request_changes")
          @inscription.status = "in_review"
        end

        @inscription.save
        redirect_to finish_wizard_path
      else
        render 'preferences', status: :unprocessable_entity
      end
    end
  end

  def adjust_params_for_files(params)
    # Si les paramètres contiennent des attributes nested pour inscription_item_requirements
    if params[:inscription_item_requirements_attributes].present?
      # Pour chaque élément nested
      params[:inscription_item_requirements_attributes].each do |key, item_params|
        # Si le champ submitted_file contient une référence à ActiveStorage::Attached::One
        if item_params[:submitted_file].is_a?(String) && item_params[:submitted_file].include?("ActiveStorage::Attached::One")
          # Supprimer ce paramètre pour éviter l'erreur InvalidSignature
          params[:inscription_item_requirements_attributes][key].delete(:submitted_file)

          # S'assurer que nous avons au moins l'ID et l'requirement_item_id
          if item_params[:id].blank? && item_params[:requirement_item_id].blank?
            # Rechercher l'élément dans la base de données par l'index ou le key
            item_id = key.to_i
            if item_id > 0
              requirement_item = @inscription.inscription_item_requirements.find_by(id: item_id)
              if requirement_item
                params[:inscription_item_requirements_attributes][key][:id] = requirement_item.id
                params[:inscription_item_requirements_attributes][key][:requirement_item_id] = requirement_item.requirement_item_id
              end
            end
          end
        end

        # Vérifier si nous avons un item vide
        if item_params.empty? || (item_params.keys - [:id, :_destroy]).empty?
          # S'il y a un ID, ajouter le requirement_item_id
          if item_params[:id].present?
            requirement_item = @inscription.inscription_item_requirements.find_by(id: item_params[:id])
            if requirement_item
              params[:inscription_item_requirements_attributes][key][:requirement_item_id] = requirement_item.requirement_item_id
            end
          else
            # Sinon, supprimer cet élément vide
            params[:inscription_item_requirements_attributes].delete(key)
          end
        end
      end
    end

    # Log les paramètres pour débogage
    Rails.logger.debug "Adjusted params: #{params.inspect}"

    params
  end

  def finish_wizard_path
    inscription_path(@inscription)
  end

  private

  def set_inscription
    @inscription = Inscription.find(params[:inscription_id])
    authorize @inscription if defined?(Pundit)
  end

  def inscription_params
    params.require(:inscription).permit(
      :category_id,
      :status,
      :air,
      :terms_accepted,
      :payment_proof, :remove_payment_proof,
      :candidate_brings_pianist_accompagnateur,
      :candidate_brings_pianist_accompagnateur_email,
      :candidate_brings_pianist_accompagnateur_full_name,
      :time_preference,
      :time_justification,
      inscription_item_requirements_attributes: %i[id submitted_file submitted_content document_id requirement_item_id _destroy],
      choice_imposed_work_airs_attributes: [:id, :choice_imposed_work_id, :air_id],
      semi_imposed_work_airs_attributes: [:id, :semi_imposed_work_id, air_attributes: [:id, :title, :length_minutes, :composer, :oeuvre, :character, :tonality]]
    )
  end
end
