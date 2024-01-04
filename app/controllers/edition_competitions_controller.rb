class EditionCompetitionsController < ApplicationController
  before_action :set_organism_and_competition, only: [:edit, :update]

  # GET /edition_competitions or /edition_competitions.json
  def index
    @edition_competitions = EditionCompetition.all
  end

  # GET /edition_competitions/1 or /edition_competitions/1.json
  def show
    @organism = Organism.find(params[:organism_id])
    @competition = Competition.find(params[:competition_id])
    @edition_competition = EditionCompetition.find(params[:id])
    @categories = @edition_competition.categories.order(created_at: :desc)
  end

  # GET /edition_competitions/new
  def new
    @organism = Organism.find(params[:organism_id])
    @competition = Competition.find(params[:competition_id])
    @edition_competition = EditionCompetition.new
    @edition_competition.build_address
  end

  # GET /edition_competitions/1/edit
  def edit
    @organism = Organism.find(params[:organism_id])
    @competition = Competition.find(params[:competition_id])
    @edition_competition = EditionCompetition.find(params[:id])
  end

  # POST /edition_competitions or /edition_competitions.json
  def create
    @organism = Organism.find(params[:organism_id])
    @competition = Competition.find(params[:competition_id])
    @edition_competition = @competition.edition_competitions.build(edition_competition_params)
    if @edition_competition.save
      redirect_to organism_competition_path(@organism, @competition), notice: 'Edition was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /edition_competitions/1 or /edition_competitions/1.json
  def update
    respond_to do |format|
      if @edition_competition.update(edition_competition_params)
        format.html { redirect_to edition_competition_url(@edition_competition), notice: "Edition competition was successfully updated." }
        format.json { render :show, status: :ok, location: @edition_competition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @edition_competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edition_competitions/1 or /edition_competitions/1.json
  def destroy
    unless @edition_competition.destroy
      @edition_competition.errors.full_messages.each do |message|
        puts message
      end
    end
    redirect_to competitions_url(@edition_competition.competition), notice: "Edition competition was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organism_and_competition
      @edition_competition = EditionCompetition.find(params[:id])
      @competition = @edition_competition.competition
      @organism = @competition.organism
    end

    # Only allow a list of trusted parameters through.
    def edition_competition_params
      params.require(:edition_competition).permit(
        :competition_id,
        :annee,
        :details_specifiques,
        :start_date,
        :end_date,
        :end_of_registration,
        address_attributes: [:line1, :line2, :zipcode, :city, :country],
        documents_attributes: [:file, :file_url, :document_type]
      )
    end
end
