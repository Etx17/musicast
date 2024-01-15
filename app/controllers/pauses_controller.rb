class PausesController < ApplicationController
  before_action :set_tour

  def new
    @organism = Organism.find(params[:organism_id])
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

      redirect_to request.referrer || root_path

    else
      # handle an unsuccessful save
      redirect_to request.referrer || root_path
    end
  end

  def delete
    # remove pause from schedule
    # delete logic
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
      end
    end
  end

  def remove_pause_from_schedule
  end

  def set_tour
    @tour = Tour.find(params[:tour_id])
  end

  def pause_params
    params.require(:pause).permit(:start_time, :end_time, :date)
  end
end
