class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_breadcrumbs
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def make_me_admin
    return head :forbidden unless Rails.env.development?

    user_id = params[:user_id]
    user = User.find(user_id)

    unless user
      flash[:alert] = "Utilisateur non trouvé"
      return redirect_to root_path
    end

    user.update(admin: true)

    flash[:notice] = "Vous êtes maintenant administrateur"
    redirect_to request.referrer || root_path
  end

  def set_breadcrumbs
    add_breadcrumb "Tableau de bord", organisateur_dashboard_path if current_user&.organisateur&.present?
    path = request.path.split('/')
    path.each_with_index do |segment, index|
      next if segment.empty? || index == 1 || path[index - 1] == "organisms" || segment == "categories" || segment == "edition_competitions" || segment == "competitions"
      next if segment == "organisms"  # because it points to a list of organisms
      next if segment == "candidats" # because it points to a list of candidates
      if path[index - 1] == "edition_competitions" && segment != "new"
        edition_competition = EditionCompetition.find(segment)
        add_breadcrumb "#{edition_competition.annee}", URI.join(root_url, "#{path[0..index].join('/')}").to_s
      else
        title = segment.tr('-', ' ').titleize
        add_breadcrumb "#{title}", URI.join(root_url, "#{path[0..index].join('/')}").to_s
      end
    end

  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:inscription_role, :accepted_terms, :accepts_newsletter])
    devise_parameter_sanitizer.permit(:account_update, keys: [:accepted_terms, :accepts_newsletter])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :email, :inscription_role, :accepted_terms, :accepts_newsletter])

  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
