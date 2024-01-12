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
    if @tour.update(tour_params)
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Tour mis à jour avec succès."
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

    # head :ok
    # # i need to redirect to my current page, so that it refreshes it

    redirect_to request.referrer
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
