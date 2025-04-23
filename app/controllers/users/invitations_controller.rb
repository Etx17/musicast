class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
    @user.build_jury
    super
  end

  def create
    # Cas ou on un organisme invite un candidat pour une inscription tardive mais que le candidat est déjà inscrit
    existing_user = User.find_by_email(params["user"]["email"])
    if existing_user && existing_user.candidat
      category = Category.find(params["user"]["category_id"])
      existing_inscription = Inscription.find_by(candidat: existing_user.candidat, category: category)

      if existing_inscription
        existing_inscription.update(is_late_inscription: true)
      else
        Inscription.create(is_late_inscription: true, candidat: existing_user.candidat, category: category, terms_accepted: true)
      end
      # Notifier le candidat
      flash[:notice] = "Candidat déjà inscrit, inscription mise à jour"
      redirect_back(fallback_location: root_path)
      return
    end


    @user = User.invite!(invite_params) do |u|
      u.skip_invitation = true
    end


    super
    if @user.errors.empty?
      case @user.inscription_role
      when "jury"
        @user.jury.email = @user.email
        if @user.jury.save
          OrganismJury.create(organism: current_user.organisateur.organism, jury: @user.jury)
        end
        # @user.deliver_invitation
      when "candidate"
        if @user.candidat.update(first_name: params["user"]["candidat"]["first_name"], last_name: params["user"]["candidat"]["last_name"])
          Inscription.create(is_late_inscription: true, candidat: @user.candidat, category: Category.find(params["user"]["category_id"]), terms_accepted: true)
        end
        # @user.deliver_invitation
      end

      # redirect_back(fallback_location: root_path)
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
