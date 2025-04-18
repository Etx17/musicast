require 'zip'

class PerformancesController < ApplicationController
  before_action :set_performance, only: [:show, :edit, :update, :destroy]

  def new
    @inscription = Inscription.find(params[:inscription_id])
    @tour = Tour.find(params[:tour_id])
    @performance = Performance.new(inscription: @inscription, tour: @tour)
  end

  def create
    @inscription = Inscription.find(params[:inscription_id])
    @tour = Tour.find(params[:performance][:tour_id])

    
    processed_params = performance_params
    processed_params[:air_selection] = processed_params[:air_selection].reject(&:empty?) if processed_params[:air_selection].present?

    
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
    authorize @performance
  end

  def update
    moved = false
    air_id_to_move = nil
    direction = nil

    if params[:move_up].present?
      moved = true
      air_id_to_move = params[:move_up]
      direction = :up
    elsif params[:move_down].present?
      moved = true
      air_id_to_move = params[:move_down]
      direction = :down
    end

    if moved && air_id_to_move
      
      ordered_airs = @performance.ordered_air_selection || []
      index = ordered_airs.index(air_id_to_move)

      if index.nil?
        flash[:alert] = "Air not found in performance for reordering."
        redirect_to inscription_path(@performance.inscription), status: :unprocessable_entity
        return
      end

      new_index = direction == :up ? index - 1 : index + 1

      
      if new_index >= 0 && new_index < ordered_airs.length
        ordered_airs.insert(new_index, ordered_airs.delete_at(index))
        @performance.ordered_air_selection = ordered_airs
        
        save_successful = @performance.save
      else
        
        
        save_successful = true
      end

      if save_successful
        redirect_to inscription_path(@performance.inscription), notice: 'Air order updated.'
      else
        flash[:alert] = "Failed to reorder airs."
        
        redirect_to inscription_path(@performance.inscription), status: :unprocessable_entity
      end

    else
      
      if @performance.update(performance_params)
        redirect_to inscription_path(@performance.inscription), notice: 'Performance was successfully updated.'
      else
        render :edit, status: :unprocessable_entity 
      end
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

  def download_scores
    @performance = Performance.find(params[:id]) 
    scores_to_zip = @performance.scores.attached? ? @performance.scores.to_a : [] 

    if scores_to_zip.empty?
      redirect_back fallback_location: root_path, alert: "No scores found attached to this specific performance."
      return
    end

    
    temp_file = Tempfile.new(["performance_#{@performance.id}_scores", '.zip'])
    
    participant_name = @performance.inscription&.candidat&.full_name || "performance_#{@performance.id}"
    zip_filename = "#{participant_name}_scores.zip"

    begin
      
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        scores_to_zip.each do |score|
          
          blob_data = score.blob.download
          zipfile.get_output_stream(score.filename.to_s) do |f|
            f.write(blob_data)
          end
        end
      end

      
      zip_data = File.read(temp_file.path)
      
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: zip_filename)

    ensure
      
      temp_file.close
      temp_file.unlink
    end
  end

  private

  def set_performance
    @performance = Performance.find(params[:id])
    authorize @performance
  end

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

  def helpers
    ApplicationController.helpers
  end
end
