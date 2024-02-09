class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_breadcrumbs
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  def set_breadcrumbs
    add_breadcrumb "Tableau de bord", organisateur_dashboard_path if current_user&.organisateur&.present?
    path = request.path.split('/')
    path.each_with_index do |segment, index|
      next if segment.empty? || index == 1 || path[index - 1] == "organisms" || segment == "categories" || segment == "edition_competitions" || segment == "competitions"

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
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
