class FreeChoiceAirsController < ApplicationController
  before_action :set_free_choice_air, only: %i[ show edit update destroy ]

  # GET /free_choice_airs or /free_choice_airs.json
  def index
    @free_choice_airs = FreeChoiceAir.all
  end

  # GET /free_choice_airs/1 or /free_choice_airs/1.json
  def show
  end

  # GET /free_choice_airs/new
  def new
    @free_choice_air = FreeChoiceAir.new
  end

  # GET /free_choice_airs/1/edit
  def edit
  end

  # POST /free_choice_airs or /free_choice_airs.json
  def create
    @free_choice_air = FreeChoiceAir.new(free_choice_air_params)

    respond_to do |format|
      if @free_choice_air.save
        format.html { redirect_to free_choice_air_url(@free_choice_air), notice: "Free choice air was successfully created." }
        format.json { render :show, status: :created, location: @free_choice_air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @free_choice_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /free_choice_airs/1 or /free_choice_airs/1.json
  def update
    respond_to do |format|
      if @free_choice_air.update(free_choice_air_params)
        format.html { redirect_to free_choice_air_url(@free_choice_air), notice: "Free choice air was successfully updated." }
        format.json { render :show, status: :ok, location: @free_choice_air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @free_choice_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /free_choice_airs/1 or /free_choice_airs/1.json
  def destroy
    @free_choice_air.destroy

    respond_to do |format|
      format.html { redirect_to free_choice_airs_url, notice: "Free choice air was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_free_choice_air
      @free_choice_air = FreeChoiceAir.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def free_choice_air_params
      params.require(:free_choice_air).permit(:free_choice_id, :air_id)
    end
end
