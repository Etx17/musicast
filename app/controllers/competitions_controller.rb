class CompetitionsController < ApplicationController
  before_action :set_competition, only: %i[ show edit update destroy ]
  before_action :set_organism, only: %i[ show new edit create update ]

  # GET /competitions or /competitions.json
  def index
    @competitions = Competition.all
  end

  # GET /competitions/1 or /competitions/1.json
  def show
    @edition_competition = EditionCompetition.new
    @categories = @competition.edition_competitions.map(&:categories).flatten
    @categories = @categories.sort_by(&:discipline)

  end

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions or /competitions.json
  def create
    @competition = Competition.new(competition_params)
    @competition.organism = @organism

    if @competition.save
      redirect_to organism_competition_path(@organism, @competition), notice: "Competition was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /competitions/1 or /competitions/1.json
  def update
    if @competition.update(competition_params)
      redirect_to organism_competition_path(@organism,@competition), notice: "Competition was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /competitions/1 or /competitions/1.json
  def destroy
    @competition.destroy
    redirect_to organisateur_dashboard_path, notice: "Competition was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    def set_organism
      @organism = Organism.find(params[:organism_id])
    end

    # Only allow a list of trusted parameters through.
    def competition_params
      params.require(:competition).permit(:organism_id, :nom_concours, :description, :photo)
    end
end
