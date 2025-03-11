class ImposedWorksController < ApplicationController
  before_action :set_imposed_work, only: %i[show edit update destroy]
  before_action :set_category, only: %i[new edit create update destroy]
  before_action :set_edition_competition, only: %i[new edit create update destroy]

  def index
    @imposed_works = ImposedWork.all
  end

  def show
  end

  def new
    @imposed_work = @category.build_imposed_work
    @imposed_work.airs.build
  end

  def edit
    @imposed_work = ImposedWork.find(params[:id])
  end

  def create
    @imposed_work = @category.build_imposed_work(imposed_work_params)
    if @imposed_work.save
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Imposed work was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @imposed_work = ImposedWork.find(params[:id])
    if @imposed_work.update(imposed_work_params)
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Imposed work was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @imposed_work = ImposedWork.find(params[:id])
    @imposed_work.airs.destroy_all if @imposed_work.airs.any?
    if @imposed_work.destroy
      redirect_to(params[:redirect_path] || root_path, notice: "Imposed work was successfully destroyed.")
    else
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                 alert: "Failed to destroy imposed work: #{@imposed_work.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_imposed_work
    @imposed_work = ImposedWork.find(params[:id])
  end

  def set_category
    @category = Category.friendly.find(params[:category_id])
    @organism = @category.edition_competition.organism
    @competition = @category.edition_competition.competition
  end

  def set_edition_competition
    @edition_competition = EditionCompetition.find(params[:edition_competition_id])
  end

  def imposed_work_params
    params.require(:imposed_work).permit(
      :id,
      :programme_requirement_id,
      :title,
      :title_english,
      :guidelines,
      :guidelines_english,
      :category_id,
      airs_attributes: %i[
        id
        title
        composer
        length_minutes
        tonality
        character
        infos
        oeuvre
        _destroy
      ]
    )
  end
end
