class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs

  private

  def set_breadcrumbs
    add_breadcrumb "Tableau de bord", organisateur_dashboard_path if current_user.organisateur.present?
    path = request.path.split('/')
    path.each_with_index do |segment, index|
      next if segment.empty? || !(segment =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/) || index == 1 || path[index - 1] == "organisms"
      add_breadcrumb "#{path[index - 1].singularize.titleize} #{segment}", URI.join(root_url, "#{path[0..index].join('/')}").to_s
    end
  end

  # def set_breadcrumbs
  #   add_breadcrumb "Tableau de bord", organisateur_dashboard_path if current_user.organisateur.present?
  #   path = request.path.split('/')
  #   path.each_with_index do |segment, index|
  #     next if segment.empty? || index == 1 || path[index - 1] == "organisms"
  #     if segment =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/ && path[index - 1] == "competitions"
  #       competition = Competition.friendly.find(segment)
  #       add_breadcrumb competition.name, URI.join(root_url, "#{path[0..index].join('/')}").to_s
  #     else
  #       add_breadcrumb segment.titleize, URI.join(root_url, "#{path[0..index].join('/')}").to_s
  #     end
  #   end
  # end
end
