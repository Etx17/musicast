class SemiImposedWorkAirsController < ApplicationController
  before_action :set_semi_imposed_work_air, only: %i[ show edit update destroy ]

  # GET /semi_imposed_work_airs or /semi_imposed_work_airs.json
  def index
    @semi_imposed_work_airs = SemiImposedWorkAir.all
  end

  # GET /semi_imposed_work_airs/1 or /semi_imposed_work_airs/1.json
  def show
  end

  # GET /semi_imposed_work_airs/new
  def new
    @semi_imposed_work_air = SemiImposedWorkAir.new
  end

  # GET /semi_imposed_work_airs/1/edit
  def edit
  end

  # POST /semi_imposed_work_airs or /semi_imposed_work_airs.json
  def create
    @semi_imposed_work_air = SemiImposedWorkAir.new(semi_imposed_work_air_params)

    respond_to do |format|
      if @semi_imposed_work_air.save
        format.html { redirect_to semi_imposed_work_air_url(@semi_imposed_work_air), notice: "Semi imposed work air was successfully created." }
        format.json { render :show, status: :created, location: @semi_imposed_work_air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @semi_imposed_work_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semi_imposed_work_airs/1 or /semi_imposed_work_airs/1.json
  def update
    respond_to do |format|
      if @semi_imposed_work_air.update(semi_imposed_work_air_params)
        format.html { redirect_to semi_imposed_work_air_url(@semi_imposed_work_air), notice: "Semi imposed work air was successfully updated." }
        format.json { render :show, status: :ok, location: @semi_imposed_work_air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @semi_imposed_work_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semi_imposed_work_airs/1 or /semi_imposed_work_airs/1.json
  def destroy
    @semi_imposed_work_air.destroy

    respond_to do |format|
      format.html { redirect_to semi_imposed_work_airs_url, notice: "Semi imposed work air was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_semi_imposed_work_air
      @semi_imposed_work_air = SemiImposedWorkAir.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def semi_imposed_work_air_params
      params.require(:semi_imposed_work_air).permit(:semi_imposed_work_id, :air_id)
    end
end
