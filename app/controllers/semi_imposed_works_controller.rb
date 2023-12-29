class SemiImposedWorksController < ApplicationController
  before_action :set_semi_imposed_work, only: %i[ show edit update destroy ]

  # GET /semi_imposed_works or /semi_imposed_works.json
  def index
    @semi_imposed_works = SemiImposedWork.all
  end

  # GET /semi_imposed_works/1 or /semi_imposed_works/1.json
  def show
  end

  # GET /semi_imposed_works/new
  def new
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @semi_imposed_work = SemiImposedWork.new()
  end

  # GET /semi_imposed_works/1/edit
  def edit
  end

  # POST /semi_imposed_works or /semi_imposed_works.json
  def create
    @competition = Competition.find(params[:competition_id])
    @edition_competition = @competition.edition_competitions.find(params[:edition_competition_id])
    @category = @edition_competition.categories.find(params[:category_id])
    @semi_imposed_work = @category.semi_imposed_works.build(semi_imposed_work_params)
    if @semi_imposed_work.save
      redirect_to category_path(@category), notice: "Semi imposed work was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /semi_imposed_works/1 or /semi_imposed_works/1.json
  def update
    respond_to do |format|
      if @semi_imposed_work.update(semi_imposed_work_params)
        format.html { redirect_to category_path(@semi_imposed_work.category), notice: "Semi imposed work was successfully updated." }
        format.json { render :show, status: :ok, location: @semi_imposed_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @semi_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semi_imposed_works/1 or /semi_imposed_works/1.json
  def destroy
    @semi_imposed_work.destroy

    redirect_to category_path(@semi_imposed_work.category), notice: "Semi imposed work was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_semi_imposed_work
      @semi_imposed_work = SemiImposedWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def semi_imposed_work_params
      params.require(:semi_imposed_work).permit(:programme_requirement_id, :guidelines, :title, :number, :max_length_minutes)
    end
end
