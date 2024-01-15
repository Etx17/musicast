class ToursController < ApplicationController
  before_action :set_tour, only: %i[show edit update destroy update_order]
  before_action :set_context, only: %i[new create show edit update destroy update_order]

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
    creating_schedule = params[:tour].delete(:creating_schedule)

    if @tour.update(tour_params)
      if creating_schedule == "true"
        @tour.generate_performance_schedule
        redirect_to organism_competition_edition_competition_category_tour_path(@organism, @competition, @edition_competition, @category, @tour), notice: "Tour schedule has been updated." and return
      else
        redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category), notice: "Tour mis à jour avec succès."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tour.destroy
    redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                notice: "Tour supprimé."
  end

  def update_order
    @tour.update_performance_order(params[:performance_id], params[:new_order])

    redirect_to request.referrer || root_path
  end

  def schedule
    @tour = Tour.find(params[:id])
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
      tour_requirement_attributes: [
        :id,
        :description,
        :min_number_of_works,
        :max_number_of_works,
        :min_duration_minute,
        :max_duration_minute,
        :organiser_creates_program
      ]
    )
  end
end
