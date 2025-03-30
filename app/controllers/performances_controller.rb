class PerformancesController < ApplicationController

  def new
    @inscription = Inscription.find(params[:inscription_id])
    @tour = Tour.find(params[:tour_id])
    @performance = Performance.new(inscription: @inscription, tour: @tour)
  end

  def create
    @inscription = Inscription.find(params[:inscription_id])
    @tour = Tour.find(params[:performance][:tour_id])

    # Process performance params
    processed_params = performance_params
    processed_params[:air_selection] = processed_params[:air_selection].reject(&:empty?) if processed_params[:air_selection].present?

    # Make sure imposed airs are always included
    if @tour.imposed_air_selection.present?
      processed_params[:air_selection] ||= []
      processed_params[:air_selection] += @tour.imposed_air_selection
      processed_params[:air_selection].uniq!
    end

    @performance = Performance.new(processed_params.merge(inscription: @inscription, tour: @tour))

    if @performance.save
      redirect_to @performance.inscription, notice: t('performances.create.success')
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

    # Ensure air_selection is an array of IDs
    if params[:performance][:air_selection].present?
      params[:performance][:air_selection] = params[:performance][:air_selection].map(&:to_s)
    else
      # If no airs were selected, initialize with an empty array
      params[:performance][:air_selection] = []
    end

    # Make sure imposed airs are always included
    if @performance.tour.imposed_air_selection.present?
      params[:performance][:air_selection] += @performance.tour.imposed_air_selection
      params[:performance][:air_selection].uniq!
    end

    if @performance.update(performance_params)
      redirect_to inscription_path(@performance.inscription), notice: t('performances.update.success')
    else
      render :edit
    end
  end

  def upload_scores
    @performance = Performance.find(params[:id])
    if params[:scores].present?
      @performance.scores.attach(params[:scores])
      redirect_to @performance.inscription
    else
      redirect_to @performance.inscription
    end
  end

  def delete_score
    @performance = Performance.find(params[:id])
    score = @performance.scores.find(params[:score_id])
    score.purge
    redirect_to @performance.inscription
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
      scores: [],
      ordered_air_selection: [],
      air_selection: []).tap do |whitelisted|
        whitelisted[:air_selection] = whitelisted[:air_selection]&.reject(&:blank?)
      end
  end
end
