class EditionCompetitionsController < ApplicationController
  before_action :set_edition_competition, only: %i[ show edit update destroy ]

  # GET /edition_competitions or /edition_competitions.json
  def index
    @edition_competitions = EditionCompetition.all
  end

  # GET /edition_competitions/1 or /edition_competitions/1.json
  def show
  end

  # GET /edition_competitions/new
  def new
    @edition_competition = EditionCompetition.new
  end

  # GET /edition_competitions/1/edit
  def edit
  end

  # POST /edition_competitions or /edition_competitions.json
  def create
    @edition_competition = EditionCompetition.new(edition_competition_params)

    respond_to do |format|
      if @edition_competition.save
        format.html { redirect_to edition_competition_url(@edition_competition), notice: "Edition competition was successfully created." }
        format.json { render :show, status: :created, location: @edition_competition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @edition_competition.errors, status: :unprocessable_entity }
      end
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
    @edition_competition.destroy

    respond_to do |format|
      format.html { redirect_to edition_competitions_url, notice: "Edition competition was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edition_competition
      @edition_competition = EditionCompetition.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def edition_competition_params
      params.require(:edition_competition).permit(:competition_id, :annee, :details_specifiques)
    end
end
