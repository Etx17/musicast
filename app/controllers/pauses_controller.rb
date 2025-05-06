class PausesController < ApplicationController
  before_action :set_tour
  before_action :set_context

  def new
    @organism = Organism.friendly.find(params[:organism_id])
    @competition = @organism.competitions.find(params[:competition_id])
    @edition_competition = @competition.edition_competitions.find(params[:edition_competition_id])
    @category = @edition_competition.categories.find(params[:category_id])
    @tour = @category.tours.find(params[:tour_id])
    @pause = @tour.pauses.build
  end

  def create
    @pause = Pause.new(pause_params)
    @pause.tour = @tour
    if @pause.save
      insert_pause_in_schedule(@pause)
      # handle a successful save
      # Si la pause est crée, on doit updater toutes les performances.start_time dont la date est la même que celle de la pause, pour += @pause.duree a chacune de ces performances

      redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Pause créée avec succès"

    else
      # handle an unsuccessful save
      redirect_to [@organism, @competition, @edition_competition, @category, @tour], alert: "Erreur lors de la création de la pause"
    end
  end

  def destroy
    @pause = Pause.find(params[:id])
    remove_pause_from_schedule(@pause)

    @pause.destroy
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Pause supprimée avec succès"
  end

  private

  def insert_pause_in_schedule(pause)
    ActiveRecord::Base.transaction do
      pause_start_time = pause.start_time.strftime("%H:%M")
      performance_order = pause.tour.performances.where("start_time::time = ?", pause_start_time).order(:order).first&.order
      if performance_order
        pause.tour.performances.where(start_date: pause.date).where('"order" >= ?', performance_order).each do |performance|
          performance.update!(start_time: performance.start_time + pause.duration)
        end
        # Since we modified the performance start time, we need to destroy the candidate_rehearsals for the tour.
        pause.tour.candidate_rehearsals.destroy_all
      end
    end
  end

  def remove_pause_from_schedule(pause)
    # On ne peut delete que les pauses en partant de la fin. Si on delete une pause au milieu, on va devoir updater toutes les performances qui sont après la pause
    # For all the performances that are after the pause, we need to remove the pause duration from their start_time
    ActiveRecord::Base.transaction do
      pause_start_time = pause.start_time.strftime("%H:%M")
      performances_after_pause = pause.tour.performances.where("TO_CHAR(start_time, 'HH24:MI') > ? AND start_date = ?", pause_start_time, pause.date).order(:order)

      performances_after_pause.each do |performance|
        performance.update!(start_time: performance.start_time - pause.duration)
      end
      # Since we modified the performance start time, we need to destroy the candidate_rehearsals for the tour.
      pause.tour.candidate_rehearsals.destroy_all
    end
  end

  def set_tour
    @tour = Tour.find(params[:tour_id])
  end

  def set_context
    @organism = Organism.friendly.find(params[:organism_id])
    @category = Category.friendly.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
  end

  def pause_params
    params.require(:pause).permit(:start_time, :end_time, :date)
  end
end
