class ToursController < ApplicationController
  before_action :set_tour, only: %i[ store_form_data move_to_next_tour qualify_performance shuffle show edit update destroy update_order update_day_of_performance_and_subsequent_performances]
  before_action :set_context, only: %i[ store_form_data move_to_next_tour qualify_performance shuffle new create show edit update destroy update_order update_day_of_performance_and_subsequent_performances]

  def index
    @tours = Tour.all
  end

  def show;
    @performances = @tour.performances
    @tour.generate_initial_performance_order if @performances.any? { |p| p.order.nil? }
    # Assigner un order aux performances qui n'en ont pas.
  end

  def edit; end

  def new
    @tour = Tour.new
    @tour.build_tour_requirement
    @tour.build_pauses
  end

  def create
    @tour = Tour.new(tour_params)
    @tour.tour_requirement = TourRequirement.new(tour_params[:tour_requirement_attributes])
    @tour.category = @category
    if @tour.save
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Tour crée avec succès."
    else
      render :new
    end
  end

  def update
    # Voir que ca fait bien marcher a la fois l'update de tour a is_finished, et aussi la creation de schedule pour un tour (apres configuration)
    creating_schedule = params.fetch(:tour, {}).delete(:creating_schedule) { false }
    if @tour.update(tour_params)
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

  def qualify_performance
    performance = Performance.find(params[:performance_id])
    performance.update(is_qualified: !performance.is_qualified)
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Performance qualifiée avec succès."
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
    session[:order_of_passage] = params[:order_of_passage] == "1"
    redirect_to [@organism, @competition, @edition_competition, @category, @tour], notice: "Données du planning jury sauvegardées."
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
      :title, :description,
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
        :min_number_of_works,
        :max_number_of_works,
        :min_duration_minute,
        :max_duration_minute,
        :organiser_creates_program
      ],
      :imposed_air_selection => [],
    ).tap do |whitelisted|
      whitelisted[:imposed_air_selection] = whitelisted[:imposed_air_selection]&.reject(&:blank?)
    end
  end
end
