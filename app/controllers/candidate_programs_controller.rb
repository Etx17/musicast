class CandidateProgramsController < ApplicationController
  before_action :set_candidate_program, only: %i[ show edit update destroy ]

  # GET /candidate_programs or /candidate_programs.json
  def index
    @candidate_programs = CandidateProgram.all
  end

  # GET /candidate_programs/1 or /candidate_programs/1.json
  def show
  end

  # GET /candidate_programs/new
  def new
    @candidate_program = CandidateProgram.new
  end

  # GET /candidate_programs/1/edit
  def edit
  end

  # POST /candidate_programs or /candidate_programs.json
  def create
    @candidate_program = CandidateProgram.new(candidate_program_params)

    respond_to do |format|
      if @candidate_program.save
        format.html { redirect_to candidate_program_url(@candidate_program), notice: "Candidate program was successfully created." }
        format.json { render :show, status: :created, location: @candidate_program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @candidate_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidate_programs/1 or /candidate_programs/1.json
  def update
    respond_to do |format|
      if @candidate_program.update(candidate_program_params)
        format.html { redirect_to candidate_program_url(@candidate_program), notice: "Candidate program was successfully updated." }
        format.json { render :show, status: :ok, location: @candidate_program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @candidate_program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_programs/1 or /candidate_programs/1.json
  def destroy
    @candidate_program.destroy

    respond_to do |format|
      format.html { redirect_to candidate_programs_url, notice: "Candidate program was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate_program
      @candidate_program = CandidateProgram.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def candidate_program_params
      params.require(:candidate_program).permit(:inscription_id)
    end
end
