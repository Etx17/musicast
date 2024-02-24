class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
    @user.build_jury
    super
  end

  def create

    @user = User.invite!(invite_params) do |u|
      u.skip_invitation = true
    end

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
      super
      # redirect_back(fallback_location: root_path)
    end
  end

  def update
    super
  end


  protected

  def configure_permitted_parameters
    super
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :inscription_role, jury_attributes: [:first_name, :last_name], candidat_attributes: [:first_name, :last_name]])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:email, :inscription_role, jury_attributes: [:first_name, :last_name], candidat_attributes: [:first_name, :last_name]])
  end

  def jury_params
    params.require(:user).permit(:inscription_role, :email, jury_attributes: [:first_name, :last_name, :email])
  end

  def candidat_params
    params.require(:user).permit(:inscription_role, :email, candidat_attributes: [:first_name, :last_name])
  end


  def after_invite_path_for(resource)
    request.referrer
  end

end
