# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in

  # def create
  #   if @user.needs_to_accept_terms?
  #     redirect_to new_terms_path
  #   else
  #     super
  #   end
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  protected

  def after_sign_in_path_for(resource)
    if Organisateur.exists?(user: resource)
      organisateur_dashboard_path
    elsif Candidat.exists?(user: resource)
      candidat_dashboard_path
    elsif Jury.exists?(user: resource)
      jury_dashboard_path
    elsif Partner.exists?(user: resource)
      partner_dashboard_path
    else
      pages_home_path
    end
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
