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
    @room = Room.build
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
          @tour.candidate_rehearsals.destroy_all
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
      tour.candidate_rehearsals.destroy_all
    end

    # Redirect to the tour page
    redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: 'Le jour de la performance et des performances suivantes ont été mis à jour. Veuillez régénerer le planning de répétition si vous en aviez configuré un.'
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
      @tour.candidate_rehearsals.destroy_all
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
      @tour.candidate_rehearsals.destroy_all
    end

    @tour.generate_initial_performance_order
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: t('tours.shuffle.success')
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

    # Since we change the pianists, we need to regenerate the pianist rehearsal schedule if there was one
    @tour.candidate_rehearsals&.destroy_all if @tour.pianist_rehearsal?

    @tour.assign_pianist_to_each_performance(pianists, max_consecutive_performances_per_pianist, min_consecutive_performances_per_pianist)
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Pianistes assignés avec succès."
  end

  def assign_pianist_to_performance_manually
    @performance = Performance.find(params[:performance_id])
    @performance.assign_pianist_accompagnateur(params[:pianist_accompagnateur_id])

    # Since we change the pianist, we need to regenerate the pianist rehearsal schedule
    @tour.candidate_rehearsals&.destroy_all if @tour.pianist_rehearsal?
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: 'Pianist was successfully updated. Please regenerate the pianist rehearsal schedule if you had one.'
  end

  def qualify_performance
    performance = Performance.find(params[:performance_id])
    if performance.update(is_qualified: !performance.is_qualified)
      redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Performance qualified successfully."
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

    # Program options
    @detailed_program = session[:detailed_program]
    @simple_air = session[:simple_air]

    # Biography options
    @short_bio = session[:short_bio]
    @medium_bio = session[:medium_bio]
    @short_bio_en = session[:short_bio_en]
    @medium_bio_en = session[:medium_bio_en]

    # Photo options
    @profile_photo = session[:profile_photo]

    # Additional options
    @notes_space = session[:notes_space]
    @order_of_passage = session[:order_of_passage]

    # Candidate information
    @full_name = session[:full_name]
    @nationality = session[:nationality]
    @birth_date = session[:birth_date]
    @voice_type = session[:voice_type]

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Dossier jury - #{@tour.title}",
        template: "tours/show_jury_pdf",
        layout: 'pdf',
        formats: [:html],
              orientation: 'Portrait',
              margin: { top: 15, bottom: 15, left: 15, right: 15 },
              image_quality: 100,
              dpi: 300
      end
    end
  end

  def store_form_data
    # Program options
    session[:detailed_program] = params[:detailed_program] == "1"
    session[:simple_air] = params[:simple_air] == "1"

    # Biography options - French
    case params[:bio_fr_type]
    when "short"
      session[:short_bio] = true
      session[:medium_bio] = false
    when "medium"
      session[:short_bio] = false
      session[:medium_bio] = true
    when "none"
      session[:short_bio] = false
      session[:medium_bio] = false
    end

    # Biography options - English
    case params[:bio_en_type]
    when "short"
      session[:short_bio_en] = true
      session[:medium_bio_en] = false
    when "medium"
      session[:short_bio_en] = false
      session[:medium_bio_en] = true
    when "none"
      session[:short_bio_en] = false
      session[:medium_bio_en] = false
    end

    # Photo options
    session[:profile_photo] = params[:profile_photo] == "1"

    # Additional options
    session[:notes_space] = params[:notes_space] == "1"
    session[:order_of_passage] = params[:order_of_passage] == "1"

    # Candidate information
    session[:full_name] = params[:full_name] == "1"
    session[:nationality] = params[:nationality] == "1"
    session[:birth_date] = params[:birth_date] == "1"
    session[:voice_type] = params[:voice_type] == "1"

    redirect_to show_jury_pdf_organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour)
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
      @tour.generate_solo_warmup_schedule
      redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour),
                  notice: "Configuration des répétitions mise à jour avec succès."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def download_warmup_schedule
    @tour = Tour.find(params[:id])
    authorize @tour

    # Regrouper les répétitions par jour
    @rehearsals_by_day = @tour.candidate_rehearsals.order(:start_time).group_by do |rehearsal|
      rehearsal.start_time.to_date
    end

    respond_to do |format|
      format.pdf do
        render pdf: "planning_chauffe_#{@tour.title.parameterize}",
               template: "tours/warmup_schedule",
               layout: "pdf",
               orientation: "Portrait",
               page_size: "A4",
               encoding: "UTF-8",
               footer: {
                 center: "Planning de chauffe - #{@tour.title}",
                 left: Date.today.strftime("%d/%m/%Y")
               }
      end
    end
  end

  def update_pianist_rehearsal
    @organism = Organism.friendly.find(params[:organism_id])
    @category = Category.friendly.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = @category.tours.find(params[:id])

    if @tour.update(pianist_rehearsal_params)
      # @tour.generate_pianist_rehearsal_schedule
      generate_pianist_rehearsal_schedule

      redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour),
                  notice: "Pianist rehearsal configuration updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def download_pianist_rehearsal_schedule
    @tour = Tour.find(params[:id])
    authorize @tour

    # Group rehearsals by room and pianist
    rehearsals_by_room_and_pianist = {}

    if @tour.rooms.count >= @tour.pianist_accompagnateurs.count
      # One-to-one assignment: one room per pianist
      @tour.pianist_accompagnateurs.each_with_index do |pianist, index|
        room = @tour.rooms[index] if index < @tour.rooms.count
        pianist_id = pianist.id
        room_id = room&.id

        if room_id
          key = "#{room_id}_#{pianist_id}"
          rehearsals_by_room_and_pianist[key] = {
            room: room,
            pianist: pianist,
            rehearsals: @tour.candidate_rehearsals.where(pianist_accompagnateur_id: pianist_id, room_id: room_id).order(:start_time)
          }
        end
      end
    else
      # Shared mode: group by pianist regardless of room
      @tour.pianist_accompagnateurs.each do |pianist|
        pianist_rehearsals = @tour.candidate_rehearsals.where(pianist_accompagnateur_id: pianist.id).order(:start_time)

        # Group this pianist's rehearsals by room
        pianist_rehearsals.group_by(&:room_id).each do |room_id, rehearsals|
          room = Room.find_by(id: room_id)
          next unless room

          key = "#{room_id}_#{pianist.id}"
          rehearsals_by_room_and_pianist[key] = {
            room: room,
            pianist: pianist,
            rehearsals: rehearsals
          }
        end
      end
    end

    @rehearsals_by_room_and_pianist = rehearsals_by_room_and_pianist

    respond_to do |format|
      format.pdf do
        render pdf: "pianist_rehearsal_schedule_#{@tour.title.parameterize}",
               template: "tours/pianist_rehearsal_schedule",
               layout: "pdf",
               orientation: "Portrait",
               page_size: "A4",
               encoding: "UTF-8",
               footer: {
                 center: "Pianist Rehearsal Schedule - #{@tour.title}",
                 left: Date.today.strftime("%d/%m/%Y")
               }
      end
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
      :pianist_rehearsal_start_datetime,
      :afternoon_pause_duration_minutes,
      :buffer_time_minutes,
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
    params.require(:tour).permit(:rehearse_time_slot_per_candidate, :buffer_time_minutes, room_ids: [])
  end

  def pianist_rehearsal_params
    params.require(:tour).permit(
      :pianist_rehearsal_start_datetime,
      :rehearse_time_slot_per_candidate,
      :buffer_time_minutes,
      room_ids: [],
      pianist_accompagnateur_ids: []
    )
  end

  def generate_pianist_rehearsal_schedule
    # Delete existing rehearsals to avoid duplicates
    @tour.candidate_rehearsals.destroy_all
    rooms = @tour.rooms
    pianist_accompagnateurs = @tour.performances.map(&:pianist_accompagnateur).uniq
    # Get all performances with assigned pianists
    sorted_performances = @tour.performances.where.not(pianist_accompagnateur_id: nil)
                                    .order(start_date: :asc, start_time: :asc)

    if sorted_performances.empty?
      return { success: false, message: "No performances with assigned pianists" }
    end

    # Create one-to-one mapping between pianists and rooms if possible,
    # otherwise distribute rooms among pianists
    pianist_room_map = {}

    if rooms.count >= pianist_accompagnateurs.count
      # Each pianist gets their own room
      pianist_accompagnateurs.each_with_index do |pianist, index|
        pianist_room_map[pianist.id] = rooms[index].id if index < rooms.count
      end
    else
      # Rooms are shared among pianists - assign based on a round-robin approach
      room_cycle = rooms.cycle
      pianist_accompagnateurs.each do |pianist|
        pianist_room_map[pianist.id] = room_cycle.next.id
      end
    end

    # Store room schedules to track availability
    room_schedules = {}
    rooms.each do |room|
      room_schedules[room.id] = []
    end

    # Set starting date and time for each pianist
    rehearsal_time = @tour.pianist_rehearsal_start_datetime
    # Group performances by pianist
    sorted_performances.group_by(&:pianist_accompagnateur_id).each do |pianist_id, pianist_performances|
      next unless pianist_id.present?

      # Get the room assigned to this pianist
      room_id = pianist_room_map[pianist_id]
      next unless room_id.present?

      # Schedule rehearsals for this pianist's performances
      pianist_performances.each do |performance|
        candidat = performance.inscription&.candidat
        next unless candidat

        # Calculate rehearsal end time
        rehearsal_end_time = rehearsal_time + @tour.rehearse_time_slot_per_candidate.minutes

        # Check for room availability at this time
        while @tour.room_time_conflict?(room_schedules[room_id], rehearsal_time, rehearsal_end_time)
          # Move forward by the slot duration to find next available time
          rehearsal_time += @tour.rehearse_time_slot_per_candidate.minutes
          rehearsal_end_time = rehearsal_time + @tour.rehearse_time_slot_per_candidate.minutes
        end
        # Create the rehearsal
        @tour.candidate_rehearsals.create!(
          performance: performance,
          room_id: room_id,
          candidat: candidat,
          start_time: rehearsal_time,
          end_time: rehearsal_end_time,
          pianist_accompagnateur_id: pianist_id
        )

        # Update room schedule with this reservation
        room_schedules[room_id] << { start: rehearsal_time, end: rehearsal_end_time }

        # Move to next time slot
        rehearsal_time = rehearsal_end_time + 5.minutes
      end
    end

    { success: true, message: "Pianist rehearsal schedule generated successfully", count: @tour.candidate_rehearsals.count }
  rescue => e
    { success: false, message: "Error generating pianist rehearsal schedule: #{e.message}" }
  end
end
