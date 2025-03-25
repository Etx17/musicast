class RequirementItemsController < ApplicationController
  before_action :set_competition, :set_edition_competition, :set_category, :set_organism
  before_action :set_requirement_item, only: %i[show edit update destroy]

  def index
    @requirement_items = @category.requirement_items
  end

  def new
    @requirement_item = @category.requirement_items.build
  end

  def create
    @requirement_item = @category.requirement_items.build(requirement_item_params)
    session[:active_tab] = "docs-prizes-jury-tab"
    if @requirement_item.save
      redirect_to organism_competition_edition_competition_category_path(@competition.organism, @competition, @edition_competition, @category),
                  notice: 'Requirement item was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @requirement_item.update(requirement_item_params)
      redirect_to competition_edition_competition_category_requirement_item_path(@competition, @edition_competition, @category, @requirement_item),
                  notice: 'Requirement item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    session[:active_tab] = "docs-prizes-jury-tab"
    if @requirement_item.delete
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                notice: 'La pièce requise a été supprimée.'
    else
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                alert: 'La pièce requise n\'a pas été supprimée.'
    end
  end

  private

  def set_organism
    @organism = Organism.friendly.find(params[:organism_id])
  end

  def set_competition
    @competition = Competition.friendly.find(params[:competition_id])
  end

  def set_edition_competition
    @edition_competition = @competition.edition_competitions.find(params[:edition_competition_id])
  end

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end

  def set_requirement_item
    @requirement_item = @category.requirement_items.find(params[:id])
  end

  def requirement_item_params
    params.require(:requirement_item).permit(:title, :title_english, :type_item, :description_item, :description_item_english, :category_id)
  end
end
