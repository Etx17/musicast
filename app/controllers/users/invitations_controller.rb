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
      if @user.inscription_role == "jury"
        @user.jury.email = @user.email
        if @user.jury.save
          OrganismJury.create(organism: current_user.organisateur.organism, jury: @user.jury)
        end
      end
      @user.deliver_invitation
    end

    super
  end

  def update
    super
  end


  protected

  def configure_permitted_parameters
    super
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :inscription_role, jury_attributes: [:first_name, :last_name]])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:email, :inscription_role, jury_attributes: [:first_name, :last_name]])
  end

  def jury_params
    params.require(:user).permit(:inscription_role, :email, jury_attributes: [:first_name, :last_name, :email])
  end

end
