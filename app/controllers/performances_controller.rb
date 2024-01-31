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
    authorize @performance
  end

  def update
    @performance = Performance.find(params[:id])
    authorize @performance
    
    if params[:performance][:ordered_air_selection].present?
      params[:performance][:ordered_air_selection] = JSON.parse(params[:performance][:ordered_air_selection])
    end

    updated_params = performance_params
    updated_params = updated_params.merge(air_selection: @performance.air_selection) if params[:performance][:air_selection].blank?

    if @performance.update(updated_params)
      redirect_to inscription_path(@performance.inscription)
    else
      render :edit
    end
  end



  private


  def performance_params
    params.require(:performance).permit(
      :is_qualified,
      :old_start_date,
      :heure_performance,
      :resultat,
      :tour_id,
      :inscription_id,
      :pianist_accompagnateur_id,
      :id,
      ordered_air_selection: [],
      air_selection: []).tap do |whitelisted|
        whitelisted[:air_selection] = whitelisted[:air_selection]&.reject(&:blank?)
      end
  end
end
