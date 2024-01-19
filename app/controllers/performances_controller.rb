class PerformancesController < ApplicationController
  def new
    @inscription = Inscription.find(params[:inscription_id])
    @tour = Tour.find(params[:tour_id])
    @performance = Performance.new(inscription: @inscription, tour: @tour)
  end

  def create
    @inscription = Inscription.find(params[:inscription_id])
    @tour = Tour.find(params[:performance][:tour_id])
    performance_params = performance_params()
    performance_params[:air_selection] = performance_params[:air_selection].reject(&:empty?)
    @performance = Performance.new(performance_params.merge(inscription: @inscription, tour: @tour))
    if @performance.save
      redirect_to @performance.inscription
    else
      render :new
    end
  end

  def edit
    @performance = Performance.find(params[:id])
  end

  def update
    @performance = Performance.find(params[:id])

    if @performance.update(performance_params)
      redirect_to inscription_path(@performance.inscription)
    else
      render :edit
    end
  end



  private

  def performance_params
    params.require(:performance).permit(:is_qualified, :old_start_date, :heure_performance, :resultat, :tour_id, :inscription_id, air_selection: [])
  end
end
