class ChoiceImposedWorksController < ApplicationController
  before_action :set_choice_imposed_work, only: %i[ show edit update destroy ]

  # GET /choice_imposed_works or /choice_imposed_works.json
  # def index
  #   @choice_imposed_works = ChoiceImposedWork.all
  # end

  # GET /choice_imposed_works/1 or /choice_imposed_works/1.json
  def show
  end

  # GET /choice_imposed_works/new
  def new
    @competition = Competition.find(params[:competition_id])
    @edition_competition = EditionCompetition.find(params[:edition_competition_id])
    @category = Category.find(params[:category_id])
    @choice_imposed_work = @category.choice_imposed_works.new
    @choice_imposed_work.airs.build
  end

  # GET /choice_imposed_works/1/edit
  def edit
    @organism = Organism.find(params[:organism_id])
    @competition = Competition.find(params[:competition_id])
    @edition_competition = EditionCompetition.find(params[:edition_competition_id])
    @category = Category.find(params[:category_id])
    @choice_imposed_work = ChoiceImposedWork.find(params[:id])
  end

  # POST /choice_imposed_works or /choice_imposed_works.json
  def create
    @category = Category.find(params[:category_id])
    @choice_imposed_work = @category.choice_imposed_works.new(choice_imposed_work_params)

    respond_to do |format|
      if @choice_imposed_work.save
        format.html { redirect_to category_path(@category), notice: "Liste a choix imposé créee avec succès!" }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choice_imposed_works/1 or /choice_imposed_works/1.json
  def update
    respond_to do |format|
      if @choice_imposed_work.update(choice_imposed_work_params)
        format.html { redirect_to category_path(@choice_imposed_work.category), notice: "Imposed work was successfully updated."}
        format.json { render :show, status: :ok, location: @choice_imposed_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choice_imposed_works/1 or /choice_imposed_works/1.json
  def destroy
    @choice_imposed_work.destroy


    # redirect_back fallback_location: root_path, notice: "Imposed work was successfully destroyed."
    redirect_to(params[:redirect_path] || root_path, notice: "Choice imposed work was successfully destroyed.")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_choice_imposed_work
      @choice_imposed_work = ChoiceImposedWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def choice_imposed_work_params
      params.require(:choice_imposed_work).permit(
        :programme_requirement_id,
        :title,
        :guidelines,
        :number_to_select,
        :category_id,
        :category,
        :airs_attributes => [
          :id,
          :title,
          :composer,
          :infos,
          :length_minutes,
          :tonality,
          :character,
          :oeuvre,
          :_destroy
        ]
      )
    end
end
