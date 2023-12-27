class RequirementItemsController < ApplicationController
  before_action :set_competition, :set_edition_competition, :set_category
  before_action :set_requirement_item, only: [:show, :edit, :update, :destroy]

  def index
    @requirement_items = @category.requirement_items
  end

  def new
    @requirement_item = @category.requirement_items.build
  end

  def create
    @requirement_item = @category.requirement_items.build(requirement_item_params)

    if @requirement_item.save
      redirect_to competition_edition_competition_category_path(@competition, @edition_competition, @category), notice: 'Requirement item was successfully created.'
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
      redirect_to competition_edition_competition_category_requirement_item_path(@competition, @edition_competition, @category, @requirement_item), notice: 'Requirement item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @requirement_item.destroy
    redirect_to competition_edition_competition_category_requirement_items_path(@competition, @edition_competition, @category), notice: 'Requirement item was successfully destroyed.'
  end

  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
  end

  def set_edition_competition
    @edition_competition = @competition.edition_competitions.find(params[:edition_competition_id])
  end

  def set_category
    @category = @edition_competition.categories.find(params[:category_id])
  end

  def set_requirement_item
    @requirement_item = @category.requirement_items.find(params[:id])
  end

  def requirement_item_params
    params.require(:requirement_item).permit(:title, :type_item, :description_item, :category_id)
  end
end
