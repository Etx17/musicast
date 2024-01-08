class ImposedWorksController < ApplicationController
  before_action :set_imposed_work, only: %i[show edit update destroy]

  # GET /imposed_works or /imposed_works.json
  def index
    @imposed_works = ImposedWork.all
  end

  # GET /imposed_works/1 or /imposed_works/1.json
  def show
  end

  # GET /imposed_works/new
  def new
    @category = Category.find(params[:category_id])
    @imposed_work = @category.build_imposed_work
    @imposed_work.airs.build
  end

  # GET /imposed_works/1/edit
  def edit
  end

  # POST /imposed_works or /imposed_works.json
  def create
    @category = Category.find(params[:imposed_work][:category_id])
    @imposed_work = @category.build_imposed_work(imposed_work_params)

    if @imposed_work.save
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Imposed work was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /imposed_works/1 or /imposed_works/1.json
  def update
    if @imposed_work.update(imposed_work_params)
      redirect_to organism_competition_edition_competition_category_path(@organism, @competition, @edition_competition, @category),
                  notice: "Imposed work was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /imposed_works/1 or /imposed_works/1.json
  def destroy
    @imposed_work.destroy
    redirect_to(params[:redirect_path] || root_path, notice: "Imposed work was successfully destroyed.")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_imposed_work
    @imposed_work = ImposedWork.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def imposed_work_params
    params.require(:imposed_work).permit(
      :programme_requirement_id,
      :title,
      :guidelines,
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
