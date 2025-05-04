require 'zip'
class ToursController < ApplicationController
  before_action :set_tour, only: %i[download_schedule_pdf download_pianist_scores download_all_scores download_score assign_pianist_to_performance_manually assign_pianist store_form_data move_to_next_tour qualify_performance shuffle show edit update destroy update_order update_day_of_performance_and_subsequent_performances]
  before_action :set_context, only: %i[reorder_tours assign_pianist_to_performance_manually assign_pianist store_form_data move_to_next_tour qualify_performance shuffle new create show edit update destroy update_order update_day_of_performance_and_subsequent_performances]

  def index
    @tours = Tour.all
  end

  def show;
    authorize @tour
    @performances = @tour.performances
    @tour.generate_initial_performance_order if @performances.any? { |p| p.order.nil? }
  end

  def edit;
    authorize @tour
  end

  def new
    @tour = Tour.new
    @tour.build_tour_requirement
    @tour.pauses.build
  end

  def create
    @tour = Tour.new(tour_params)
    @tour.tour_requirement = TourRequirement.new(tour_params[:tour_requirement_attributes])
    @tour.category = @category
    @tour.tour_number = @category.tours.count + 1
    session[:active_tab] = "tours-tab"
    if @tour.save
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Tour crée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Voir que ca fait bien marcher a la fois l'update de tour a is_finished, et aussi la creation de schedule pour un tour (apres configuration)
    authorize @tour
    creating_schedule = params.fetch(:tour, {}).delete(:creating_schedule) { false }
    session[:active_tab] = "tours-tab"

    update_params = tour_params
    if update_params.key?(:scores) && (update_params[:scores].blank? || update_params[:scores].all?(&:blank?))
      update_params.delete(:scores)
    end

    if @tour.update(update_params)

      if creating_schedule == "true"
        if @tour.pauses.any? || @tour.performances.any? { |p| p.start_time.present? }
          @tour.pauses.destroy_all
          @tour.performances.update_all(start_time: nil)
        end

        @tour.generate_performance_schedule
        redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: "Tour schedule has been updated." and return
      elsif params[:tour][:is_finished] == "true"
        redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: "Tour terminé."
      else
        redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category), notice: "Tour mis à jour avec succès."
      end
    else
      redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: "Erreur. Veuillez réessayer." and return if creating_schedule == "true"
      render :edit, status: :unprocessable_entity
    end
  end

  def update_day_of_performance_and_subsequent_performances
    tour = Tour.find(params[:id])
    old_start_date = params[:update_day][:old_start_date]
    new_start_date = params[:update_day][:new_start_date]

    begin
      new_start_date.to_date
    rescue ArgumentError
      flash[:error] = "Invalid date"
      redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: 'Date invalide' and return
    end

    # Find the first performance of the day
    first_performance_of_day = tour.performances.where(start_date: old_start_date).order(:order).first

    # Calculate the difference in days between the old and new start_date
    days_difference = (Date.parse(new_start_date) - Date.parse(old_start_date)).to_i
    raise 'The gap between the old and new start date is more than a year.' if days_difference.abs > 365

    # Get all subsequent performances and pauses
    subsequent_performances = tour.performances.where('"order" >= ?', first_performance_of_day.order)
    subsequent_pauses = tour.pauses.where('date >= ?', Date.parse(old_start_date))

    # Update in a transaction
    ActiveRecord::Base.transaction do
      subsequent_performances.each do |i|
        i.update!(start_date: i.start_date + days_difference)
      end
      subsequent_pauses.each do |i|
        i.update!(date: i.date + days_difference)
      end
    end

    # Redirect to the tour page
    redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: 'Le jour de la performance et des performances suivantes ont été mis à jour.'
  end

  def destroy
    @tour.destroy
    session[:active_tab] = "tours-tab"
    redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                notice: "Tour supprimé."
  end

  def update_order
    if @tour.pauses.any? || @tour.performances.any? { |p| p.start_time.present? }
      @tour.pauses.destroy_all
      @tour.performances.update_all(start_time: nil)
    end

    @tour.update_performance_order(params[:performance_id], params[:new_order])

    redirect_to request.referrer || root_path
  end

  # For a view i didn't created yet, but that will display the final schedule of the tour nicely formatted for the jury, and for the team
  def schedule
    @tour = Tour.find(params[:id])
  end

  def shuffle
    if @tour.pauses.any? || @tour.performances.any? { |p| p.start_time.present? }
      @tour.pauses.destroy_all
      @tour.performances.update_all(start_time: nil)
    end

    @tour.generate_initial_performance_order
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Ordre de passage mélangé avec succès."
  end

  def assign_pianist
    @tour = Tour.find(params[:id])
    pianists = params[:pianist_accompagnateur_ids].reject(&:blank?).map { |id| PianistAccompagnateur.find(id) }
    if pianists.count > 1
      max_consecutive_performances_per_pianist = params[:max_consecutive_performances_per_pianist].presence&.to_i || 2
      min_consecutive_performances_per_pianist = params[:min_consecutive_performances_per_pianist].presence&.to_i || 1
    else
      max_consecutive_performances_per_pianist = params[:max_consecutive_performances_per_pianist].presence&.to_i || 255
      min_consecutive_performances_per_pianist = params[:min_consecutive_performances_per_pianist].presence&.to_i || 1
    end

    @tour.assign_pianist_to_each_performance(pianists, max_consecutive_performances_per_pianist, min_consecutive_performances_per_pianist)
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Pianistes assignés avec succès."
  end

  def assign_pianist_to_performance_manually
    @performance = Performance.find(params[:performance_id])
    @performance.assign_pianist_accompagnateur(params[:pianist_accompagnateur_id])
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: 'Pianist was successfully updated.'
  end

  def qualify_performance
    performance = Performance.find(params[:performance_id])
    if performance.update(is_qualified: !performance.is_qualified)
      redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Performance qualifiée avec succès."
    end
  end

  def move_to_next_tour
    @tour.move_qualified_candidates_to_next_tour
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Les candidats qualifiés ont été envoyés vers le tour suivant."
  end

  def show_pdf
    @tour = Tour.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Planning fonctionnel - #{@tour.title}",
              template: "tours/show_pdf",
              layout: 'pdf',
              formats: [:html]
      end
    end
  end

  def show_jury_pdf
    @form_data = session[:form_data]
    @tour = Tour.find(params[:id])

    @detailed_program = session[:detailed_program]
    @simple_air = session[:simple_air]
    @notes_space = session[:notes_space]
    @profile_photo = session[:profile_photo]
    @artistic_photo = session[:artistic_photo]
    @short_bio = session[:short_bio]
    @medium_bio = session[:medium_bio]
    @long_bio = session[:long_bio]
    @short_bio_en = session[:short_bio_en]
    @medium_bio_en = session[:medium_bio_en]
    @long_bio_en = session[:long_bio_en]
    @order_of_passage = session[:order_of_passage]

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Dossier jury - #{@tour.title}",
        template: "tours/show_jury_pdf",
        layout: 'pdf',
        formats: [:html],
        footer: { right: '[page] / [topage]' }
      end
    end
  end

  def store_form_data

    session[:detailed_program] = params[:detailed_program] == "1"
    session[:simple_air] = params[:simple_air] == "1"
    session[:notes_space] = params[:notes_space] == "1"
    session[:profile_photo] = params[:profile_photo] == "1"
    session[:artistic_photo] = params[:artistic_photo] == "1"
    session[:short_bio] = params[:short_bio] == "1"
    session[:medium_bio] = params[:medium_bio] == "1"
    session[:long_bio] = params[:long_bio] == "1"
    session[:short_bio_en] = params[:short_bio_en] == "1"
    session[:medium_bio_en] = params[:medium_bio_en] == "1"
    session[:long_bio_en] = params[:long_bio_en] == "1"
    session[:order_of_passage] = params[:order_of_passage] == "1"
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Données du planning jury sauvegardées."
  end

  def reorder_tours
    new_order = params[:new_order]

    # Update the tour_number of each tour
    new_order.each_with_index do |tour_id, index|
      Tour.find(tour_id).update(tour_number: index + 1)
    end
    # redirect_to [@organism, @competition, @edition_competition, @category], notice: "Ordre des tours mis à jour"
  end

  def delete_score

    @tour = Tour.find(params[:id])
    @score = @tour.scores.find(params[:score_id])
    @score.purge
    respond_to do |format|
      # format.turbo_stream { render turbo_stream: turbo_stream.remove("score_#{params[:score_id]}") }
      format.html { redirect_to request.referrer }
    end
  end

  def download_pianist_scores
    # @tour is set by before_action
    begin
      # Assuming the model name is PianistAccompagnateur, adjust if different (e.g., User)
      @pianist = PianistAccompagnateur.find(params[:pianist_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back fallback_location: root_path, alert: "Pianist not found."
      return
    end

    # Find performances for this tour and pianist, eager load attachments/blobs
    performances = @tour.performances
                          .where(pianist_accompagnateur: @pianist)
                          .includes(scores_attachments: :blob)

    # Collect all attached scores from these performances
    scores_to_zip = performances.flat_map { |p| p.scores.attached? ? p.scores.to_a : [] }.compact

    if scores_to_zip.empty?
      redirect_back fallback_location: root_path, alert: "No scores found for performances assigned to #{@pianist.full_name} in this tour."
      return
    end

    # Generate a filename for the zip
    zip_filename = "#{@pianist.full_name}_#{@tour.title}_#{@tour.category.name}_scores.zip"
    temp_file = Tempfile.new(["pianist_#{@pianist.id}_tour_#{@tour.id}_scores", '.zip'])

    begin
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        scores_to_zip.each do |score_attachment|
          blob_data = score_attachment.blob.download
          # Consider prefixing with participant name if filenames might clash
          # filename_in_zip = "#{score_attachment.record.inscript
          # ion.candidat.slug}_#{score_attachment.filename.to_s}"
          filename_in_zip = score_attachment.filename.to_s # Or just the filename
          zipfile.get_output_stream(filename_in_zip) do |f|
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

  def download_schedule_pdf
    # @tour is set by before_action :set_tour
    @performances = @tour.performances.order(:start_date, :start_time)
    @pauses = @tour.pauses.order(:date, :start_time)
    all_items = (@performances.to_a + @pauses.to_a)

    grouped_by_day = all_items.group_by { |item| item.respond_to?(:start_date) ? item.start_date : item.date }

    sorted_items_within_day = grouped_by_day.transform_values do |items_on_day|
      items_on_day.sort_by(&:start_time)
    end

    @schedule_items_by_day = sorted_items_within_day.sort_by { |day, _| day }.to_h

    respond_to do |format|
      format.pdf do
        render pdf: "schedule_#{@tour.title.parameterize}_#{@tour.category.name.parameterize}",
               template: "tours/download_schedule_pdf",
               layout: 'pdf',
               formats: [:html],
               page_size: 'A4',
               orientation: 'Portrait',
               margin: { top: 10, bottom: 10, left: 10, right: 10 },
               footer: { right: '[page] / [topage]' },
               disposition: 'attachment'
      end
    end
  end

  def update_solo_warmup
    @organism = Organism.friendly.find(params[:organism_id])
    @category = Category.friendly.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = @category.tours.find(params[:id])

    if @tour.update(solo_warmup_params)
      redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour, anchor: "rehearsal"),
                  notice: "Configuration des répétitions mise à jour avec succès."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_tour
    @tour = Tour.find(params[:id])
  end

  def set_context
    @organism = Organism.friendly.find(params[:organism_id])
    @category = Category.friendly.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
  end

  def tour_params
    params.require(:tour).permit(
      :category_id,
      :is_finished,
      :start_date, :start_time,
      :end_date, :end_time,
      :is_online,
      :needs_rehearsal,
      :rehearse_time_slot_per_candidate,
      :rehearsal_type,
      :tour_number, :requires_pianist_accompanist,
      :requires_orchestra,
      :title, :description,
      :title_english, :description_english,
      :max_end_of_day_time,
      :new_day_start_time,
      :has_lunch_break,
      :lunch_start_time,
      :lunch_duration,
      :has_morning_pause,
      :morning_pause_time,
      :has_afternoon_pause,
      :afternoon_pause_time,
      :morning_pause_duration_minutes,
      :afternoon_pause_duration_minutes,
      :creating_schedule,
      :final_performance_submission_deadline,
      tour_requirement_attributes: [
        :id,
        :description,
        :description_english,
        :min_number_of_works,
        :max_number_of_works,
        :min_duration_minute,
        :max_duration_minute,
        :organiser_creates_program
      ],
      scores: [],
      imposed_air_selection: [],
    ).tap do |whitelisted|
      whitelisted[:imposed_air_selection] = whitelisted[:imposed_air_selection]&.reject(&:blank?)
    end
  end

  def solo_warmup_params
    params.require(:tour).permit(:rehearse_time_slot_per_candidate, room_ids: [])
  end
end
