require 'music_categories'

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :set_parent_resources, only: %i[show new edit create update destroy]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  def show
    @semi_imposed_work = SemiImposedWork.new
    @tour = Tour.new
    @tour.build_tour_requirement

  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
    @category.edition_competition = @edition_competition

    if @category.save
      redirect_to organism_competition_edition_competition_path(@organism, @competition, @edition_competition),
                  notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    if @category.update(category_params)
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category), notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy
    # redirect_to categories_url, notice: "Category was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def set_parent_resources
    @organism = Organism.friendly.find(params[:organism_id])
    @competition = Competition.friendly.find(params[:competition_id])
    @edition_competition = EditionCompetition.find(params[:edition_competition_id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:allow_own_pianist_accompagnateur, :photo, :edition_competition_id, :name, :description, :min_age, :max_age,
                                     :discipline)
  end
end
