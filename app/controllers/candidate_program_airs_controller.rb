class CandidateProgramAirsController < ApplicationController
  before_action :set_candidate_program_air, only: %i[ show edit update destroy ]

  # GET /candidate_program_airs or /candidate_program_airs.json
  def index
    @candidate_program_airs = CandidateProgramAir.all
  end

  # GET /candidate_program_airs/1 or /candidate_program_airs/1.json
  def show
  end

  # GET /candidate_program_airs/new
  def new
    @candidate_program_air = CandidateProgramAir.new
  end

  # GET /candidate_program_airs/1/edit
  def edit
  end

  # POST /candidate_program_airs or /candidate_program_airs.json
  def create
    @candidate_program_air = CandidateProgramAir.new(candidate_program_air_params)

    respond_to do |format|
      if @candidate_program_air.save
        format.html { redirect_to candidate_program_air_url(@candidate_program_air), notice: "Candidate program air was successfully created." }
        format.json { render :show, status: :created, location: @candidate_program_air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @candidate_program_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidate_program_airs/1 or /candidate_program_airs/1.json
  def update
    respond_to do |format|
      if @candidate_program_air.update(candidate_program_air_params)
        format.html { redirect_to candidate_program_air_url(@candidate_program_air), notice: "Candidate program air was successfully updated." }
        format.json { render :show, status: :ok, location: @candidate_program_air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @candidate_program_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_program_airs/1 or /candidate_program_airs/1.json
  def destroy
    @candidate_program_air.destroy

    respond_to do |format|
      format.html { redirect_to candidate_program_airs_url, notice: "Candidate program air was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate_program_air
      @candidate_program_air = CandidateProgramAir.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def candidate_program_air_params
      params.require(:candidate_program_air).permit(:candidate_program_id, :air_id)
    end
end
