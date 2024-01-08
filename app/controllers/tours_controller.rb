class ToursController < ApplicationController
  before_action :set_tour, only: %i[show edit update destroy]

  # GET /tours or /tours.json
  def index
    @tours = Tour.all
  end

  # GET /tours/1 or /tours/1.json
  def show
  end

  # GET /tours/1/edit
  def edit
  end

  def new
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = Tour.new
  end

  def create
    @organism = Organism.find(params[:organism_id])
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = Tour.new(tour_params)
    @tour.category = @category

    if @tour.save
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Tour crée avec succès."
    else
      render :new
    end
  end

  # PATCH/PUT /tours/1 or /tours/1.json
  def update
    @organism = Organism.find(params[:organism_id])
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = Tour.find(params[:id])
    if @tour.update(tour_params)
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Tour mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tours/1 or /tours/1.json
  def destroy
    @organism = Organism.find(params[:organism_id])
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour.destroy

    redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                notice: "Tour supprimé."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tour_params
    params.require(:tour).permit(:category_id, :start_date, :start_time, :end_date, :end_time, :is_online, :title,
                                 :description)
  end
end
