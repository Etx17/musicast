class SemiImposedWorksController < ApplicationController
  before_action :set_semi_imposed_work, only: %i[show edit update destroy]
  before_action :set_category, only: %i[new create]
  before_action :set_parents, only: %i[create destroy]

  def index
    @semi_imposed_works = SemiImposedWork.all
  end

  def show; end

  def new
    @semi_imposed_work = @category.semi_imposed_works.build
  end

  def edit; end

  def create
    @semi_imposed_work = @category.semi_imposed_works.build(semi_imposed_work_params)
    if @semi_imposed_work.save
      redirect_to [@organism, @competition, @edition_competition, @category], notice: "Semi imposed work was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @semi_imposed_work.update(semi_imposed_work_params)
      redirect_to [@semi_imposed_work.category.organism, @semi_imposed_work.category.competition, @semi_imposed_work.category.edition_competition, @semi_imposed_work.category], notice: "Semi imposed work was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @semi_imposed_work.destroy
    redirect_to [@organism, @competition, @edition_competition, @category], notice: "Semi imposed work was successfully destroyed."
  end

  private

  def set_semi_imposed_work
    @semi_imposed_work = SemiImposedWork.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end

  def set_parents
    set_category
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @organism = @competition.organism
  end

  def semi_imposed_work_params
    params.require(:semi_imposed_work).permit(:programme_requirement_id, :guidelines, :title, :number, :max_length_minutes)
  end
end
