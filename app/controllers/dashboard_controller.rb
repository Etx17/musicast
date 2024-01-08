class DashboardController < ApplicationController
  before_action :set_breadcrumbs

  def admin
  end

  def organiser
    @competitions = current_user.organisateur.organism.competitions
    @organism = current_user.organisateur.organism
  end

  def candidate
    redirect_to pages_home_path
  end

  def jury
    @jury = current_user.jury
    @next_tour = @jury.tours.where('start_date >= ?', Date.today).order(:start_date).first
  end

  def partner
  end
end
