class ChoiceImposedWorksController < ApplicationController
  before_action :set_choice_imposed_work, only: %i[show edit update destroy]
  before_action :set_parent_resources, only: %i[new edit create]

  def show
  end

  def new
    @choice_imposed_work = @category.choice_imposed_works.new
    @choice_imposed_work.airs.build
  end

  def edit
  end

  def create
    @choice_imposed_work = @category.choice_imposed_works.new(choice_imposed_work_params)

    respond_to do |format|
      if @choice_imposed_work.save
        format.html { redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category), notice: "Liste a choix imposé créee avec succès!" }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @choice_imposed_work.update(choice_imposed_work_params)
        format.html do
          redirect_to organism_competition_edition_competition_category_path(@choice_imposed_work.category.edition_competition.organism, @choice_imposed_work.category.competition, @choice_imposed_work.category.edition_competition, @choice_imposed_work.category), notice: "Imposed work was successfully updated."
        end
        format.json { render :show, status: :ok, location: @choice_imposed_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @choice_imposed_work.destroy
    redirect_to(params[:redirect_path] || root_path, notice: "Choice imposed work was successfully destroyed.")
  end

  private

  def set_choice_imposed_work
    @choice_imposed_work = ChoiceImposedWork.find(params[:id])
  end

  def set_parent_resources
    @category = Category.friendly.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @organism = @competition.organism
  end

  def choice_imposed_work_params
    params.require(:choice_imposed_work).permit(
      :programme_requirement_id,
      :title,
      :title_english,
      :guidelines,
      :guidelines_english,
      :number_to_select,
      :category_id,
      :category,
      airs_attributes: %i[
        id
        title
        composer
        infos
        length_minutes
        tonality
        character
        oeuvre
        _destroy
      ]
    )
  end
end
