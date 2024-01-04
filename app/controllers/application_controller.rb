class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs



  def set_breadcrumbs
    add_breadcrumb "Tableau de bord", organisateur_dashboard_path if current_user&.organisateur&.present?
    path = request.path.split('/')
    path.each_with_index do |segment, index|
      next if segment.empty? || index == 1 || path[index - 1] == "organisms" || segment == "categories" || segment == "edition_competitions" || segment == "competitions"
      if path[index - 1] == "edition_competitions"
        edition_competition = EditionCompetition.find(segment)
        add_breadcrumb "#{edition_competition.annee}", URI.join(root_url, "#{path[0..index].join('/')}").to_s
      else
        title = segment.tr('-', ' ').titleize
        add_breadcrumb "#{title}", URI.join(root_url, "#{path[0..index].join('/')}").to_s
      end
    end
  end

end
