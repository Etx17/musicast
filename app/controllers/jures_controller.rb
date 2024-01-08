class JuresController < ApplicationController
  before_action :set_jure, only: %i[show edit update destroy]

  # GET /jures or /jures.json
  def index
    @jures = Jure.all
  end

  # GET /jures/1 or /jures/1.json
  def show
  end

  # GET /jures/new
  def new
    @jure = Jure.new
  end

  # GET /jures/1/edit
  def edit
  end

  # POST /jures or /jures.json
  def create
    @jure = Jure.new(jure_params)

    respond_to do |format|
      if @jure.save
        format.html { redirect_to jure_url(@jure), notice: "Jure was successfully created." }
        format.json { render :show, status: :created, location: @jure }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jures/1 or /jures/1.json
  def update
    respond_to do |format|
      if @jure.update(jure_params)
        format.html { redirect_to jure_url(@jure), notice: "Jure was successfully updated." }
        format.json { render :show, status: :ok, location: @jure }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jures/1 or /jures/1.json
  def destroy
    @jure.destroy

    respond_to do |format|
      format.html { redirect_to jures_url, notice: "Jure was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_jure
    @jure = Jure.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def jure_params
    params.require(:jure).permit(:user_id, :autres_informations)
  end
end
