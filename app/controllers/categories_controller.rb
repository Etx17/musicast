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
    authorize @category
    @semi_imposed_work = SemiImposedWork.new
    @tour = Tour.new
    @tour.build_tour_requirement
    @tour.pauses.build

    session[:active_tab] ||= 'program-tab'
    @active_tab = session[:active_tab]
  end

  def new
    @category = Category.new
    authorize @category
  end

  def edit
    authorize @category
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
    @category.edition_competition = @edition_competition
    authorize @category
    if @category.save
      redirect_to organism_competition_edition_competition_path(@organism, @competition, @edition_competition),
                  notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    authorize @category
    if @category.update(category_params)
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category), notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    authorize @category

    if @category.destroy
      redirect_to organism_competition_edition_competition_path(@organism, @competition, @edition_competition), notice: "Category was successfully destroyed."
    else
      redirect_to organism_competition_edition_competition_path(@organism, @competition, @edition_competition), alert: "Category could not be destroyed."
    end
  end

  def candidates
    @category = Category.friendly.find(params[:id])
    return unless current_user.organises_category?(@category)
    @inscriptions = Inscription.by_category(@category.id)
    authorize @inscriptions
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
    params.require(:category).permit(
      :name,
      :preselection_vote_type,
      :description,
      :description_english,
      :min_age, :max_age, :discipline,
      :price_cents,
      :allow_own_pianist_accompagnateur,
      :payment_guidelines,
      :payment_guidelines_english,
      :payment_after_approval,
      :photo,
      tours_attributes: %i[id tour_number _destroy],
      ).tap do |whitelisted|
      whitelisted[:price_cents] = (whitelisted[:price_cents].to_f * 100).to_i if whitelisted[:price_cents]
    end
  end
end
