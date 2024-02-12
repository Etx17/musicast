class CategoriesJuriesController < ApplicationController
  before_action :set_categories_jury, only: [:show, :edit, :update, :destroy]

  def index
    @categories_juries = CategoriesJury.all
  end

  def show
  end

  def new
    @categories_jury = CategoriesJury.new
  end

  def edit
  end

  def create
    @categories_jury = CategoriesJury.new(categories_jury_params)
    @organism = Organism.friendly.find(params[:organism_id])
    @competition = Competition.friendly.find(params[:competition_id])
    @edition_competition = EditionCompetition.find(params[:edition_competition_id])
    @category = Category.friendly.find(params[:category_id])

    if @categories_jury.save
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category) + "#jury", notice: 'Le juré a bien été associé à cette catégorie'

    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @categories_jury.update(categories_jury_params)
      redirect_to @categories_jury, notice: 'Categories jury was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @categories_jury.destroy
    redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category) + "#jury", notice: 'Le membre du jury a bien été retiré de cette catégorie.'
  end

  private
    def set_categories_jury
      @categories_jury = CategoriesJury.find(params[:id])
    end

    def categories_jury_params
      params.require(:categories_jury).permit(:category_id, :jury_id)
    end
end
