class AirsController < ApplicationController
  before_action :set_air, only: %i[ show edit update destroy ]

  # GET /airs or /airs.json
  def index
    @airs = Air.all
  end

  # GET /airs/1 or /airs/1.json
  def show
  end

  # GET /airs/new
  def new
    @air = Air.new
  end

  # GET /airs/1/edit
  def edit
  end

  # POST /airs or /airs.json
  def create
    @air = Air.new(air_params)

    respond_to do |format|
      if @air.save
        format.html { redirect_to air_url(@air), notice: "Air was successfully created." }
        format.json { render :show, status: :created, location: @air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /airs/1 or /airs/1.json
  def update
    respond_to do |format|
      if @air.update(air_params)
        format.html { redirect_to air_url(@air), notice: "Air was successfully updated." }
        format.json { render :show, status: :ok, location: @air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airs/1 or /airs/1.json
  def destroy
    @air.destroy

    respond_to do |format|
      format.html { redirect_to airs_url, notice: "Air was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_air
      @air = Air.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def air_params
      params.require(:air).permit(:title, :length_minutes, :composer, :oeuvre, :character, :tonality)
    end
end
