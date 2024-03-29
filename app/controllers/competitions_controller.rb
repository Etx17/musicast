class CompetitionsController < ApplicationController
  before_action :set_competition, only: %i[show edit update destroy]
  before_action :set_organism, only: %i[show new edit create update]

  # GET /competitions or /competitions.json
  def index
    @competitions = Competition.all
  end

  # GET /competitions/1 or /competitions/1.json
  def show
    authorize @competition
    @edition_competition = EditionCompetition.new
    @categories = @competition.edition_competitions.map(&:categories).flatten
    @categories = @categories.sort_by(&:discipline)
    # Cache the sum of the inscription of each category of the edition_competition
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
    authorize @competition
  end

  # POST /competitions or /competitions.json
  def create
    @competition = Competition.new(competition_params)
    @competition.organism = @organism
    authorize @competition

    if @competition.save
      redirect_to organism_competition_path(@organism, @competition), notice: "Votre concours a bien été créé. Vous pouvez maintenant ajouter des éditions."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /competitions/1 or /competitions/1.json
  def update
    authorize @competition
    if @competition.update(competition_params)
      redirect_to organism_competition_path(@organism, @competition), notice: "Votre concours a bien été mis à jour"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /competitions/1 or /competitions/1.json
  def destroy
    authorize @competition
    @competition.destroy
    redirect_to organisateur_dashboard_path, notice: "Competition was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_competition
    @competition = Competition.friendly.find(params[:id])
  end

  def set_organism
    @organism = Organism.friendly.find(params[:organism_id])
  end

  # Only allow a list of trusted parameters through.
  def competition_params
    params.require(:competition).permit(:organism_id, :nom_concours, :description, :photo)
  end
end
