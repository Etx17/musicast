class ImposedWorkAirsController < ApplicationController
  before_action :set_imposed_work_air, only: %i[show edit update destroy]

  # GET /imposed_work_airs or /imposed_work_airs.json
  def index
    @imposed_work_airs = ImposedWorkAir.all
  end

  # GET /imposed_work_airs/1 or /imposed_work_airs/1.json
  def show
  end

  # GET /imposed_work_airs/new
  def new
    @imposed_work_air = ImposedWorkAir.new
  end

  # GET /imposed_work_airs/1/edit
  def edit
  end

  # POST /imposed_work_airs or /imposed_work_airs.json
  def create
    @imposed_work_air = ImposedWorkAir.new(imposed_work_air_params)

    respond_to do |format|
      if @imposed_work_air.save
        format.html do
          redirect_to imposed_work_air_url(@imposed_work_air), notice: "Imposed work air was successfully created."
        end
        format.json { render :show, status: :created, location: @imposed_work_air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @imposed_work_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imposed_work_airs/1 or /imposed_work_airs/1.json
  def update
    respond_to do |format|
      if @imposed_work_air.update(imposed_work_air_params)
        format.html do
          redirect_to imposed_work_air_url(@imposed_work_air), notice: "Imposed work air was successfully updated."
        end
        format.json { render :show, status: :ok, location: @imposed_work_air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @imposed_work_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imposed_work_airs/1 or /imposed_work_airs/1.json
  def destroy
    @imposed_work_air.destroy

    respond_to do |format|
      format.html { redirect_to imposed_work_airs_url, notice: "Imposed work air was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_imposed_work_air
    @imposed_work_air = ImposedWorkAir.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def imposed_work_air_params
    params.require(:imposed_work_air).permit(:imposed_work_id, :air_id)
  end
end
