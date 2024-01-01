class CompetitionsController < ApplicationController
  before_action :set_competition, only: %i[ show edit update destroy ]


  # GET /competitions or /competitions.json
  def index
    @competitions = Competition.all
  end

  # GET /competitions/1 or /competitions/1.json
  def show
    @organism = Organism.find(params[:organism_id])
    @competition = Competition.find(params[:id])
    @edition_competition = EditionCompetition.new
    @categories = @competition.edition_competitions.map(&:categories).flatten
    @categories = @categories.sort_by(&:discipline)
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
    @organism = Organism.find(params[:organism_id])
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions or /competitions.json
  def create
    @competition = Competition.new(competition_params)
    @organism = Organism.find(params[:organism_id])
    @competition.organism = @organism

    if @competition.save
      redirect_to organism_competition_path(@organism, @competition), notice: "Competition was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /competitions/1 or /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to competition_url(@competition), notice: "Competition was successfully updated." }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1 or /competitions/1.json
  def destroy
    @competition.destroy

    respond_to do |format|
      format.html { redirect_to competitions_url, notice: "Competition was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def competition_params
      params.require(:competition).permit(:organism_id, :nom_concours, :description, :photo)
    end
end
