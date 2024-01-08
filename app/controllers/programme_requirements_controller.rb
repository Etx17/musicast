class ProgrammeRequirementsController < ApplicationController
  before_action :set_programme_requirement, only: %i[show edit update destroy]

  # GET /programme_requirements or /programme_requirements.json
  def index
    @programme_requirements = ProgrammeRequirement.all
  end

  # GET /programme_requirements/1 or /programme_requirements/1.json
  def show
  end

  # GET /programme_requirements/new
  def new
    @programme_requirement = ProgrammeRequirement.new
  end

  # GET /programme_requirements/1/edit
  def edit
  end

  # POST /programme_requirements or /programme_requirements.json
  def create
    @programme_requirement = ProgrammeRequirement.new(programme_requirement_params)

    respond_to do |format|
      if @programme_requirement.save
        format.html do
          redirect_to programme_requirement_url(@programme_requirement),
                      notice: "Programme requirement was successfully created."
        end
        format.json { render :show, status: :created, location: @programme_requirement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @programme_requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programme_requirements/1 or /programme_requirements/1.json
  def update
    respond_to do |format|
      if @programme_requirement.update(programme_requirement_params)
        format.html do
          redirect_to programme_requirement_url(@programme_requirement),
                      notice: "Programme requirement was successfully updated."
        end
        format.json { render :show, status: :ok, location: @programme_requirement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @programme_requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programme_requirements/1 or /programme_requirements/1.json
  def destroy
    @programme_requirement.destroy

    respond_to do |format|
      format.html do
        redirect_to programme_requirements_url, notice: "Programme requirement was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_programme_requirement
    @programme_requirement = ProgrammeRequirement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def programme_requirement_params
    params.require(:programme_requirement).permit(:category_id)
  end
end
