class DashboardController < ApplicationController
  def admin
  end

  def organiser
    @competitions = current_user.organisateur.organism.competitions
    @organism = current_user.organisateur.organism
  end

  def candidate
    redirect_to competitions_path
  end

  def jury
    @jury = current_user.jury
    @next_tour = @jury.tours.where('start_date >= ?', Date.today).order(:start_date).first
  end

  def partner
  end
end
