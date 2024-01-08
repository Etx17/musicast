class OrganisateursController < ApplicationController
  before_action :set_organisateur, only: %i[show edit update destroy]

  # GET /organisateurs or /organisateurs.json
  def index
    @organisateurs = Organisateur.all
  end

  # GET /organisateurs/1 or /organisateurs/1.json
  def show
  end

  # GET /organisateurs/new
  def new
    @organisateur = Organisateur.new
  end

  # GET /organisateurs/1/edit
  def edit
  end

  # POST /organisateurs or /organisateurs.json
  def create
    @organisateur = Organisateur.new(organisateur_params)

    respond_to do |format|
      if @organisateur.save
        format.html { redirect_to organisateur_url(@organisateur), notice: "Organisateur was successfully created." }
        format.json { render :show, status: :created, location: @organisateur }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organisateur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organisateurs/1 or /organisateurs/1.json
  def update
    respond_to do |format|
      if @organisateur.update(organisateur_params)
        format.html { redirect_to organisateur_url(@organisateur), notice: "Organisateur was successfully updated." }
        format.json { render :show, status: :ok, location: @organisateur }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organisateur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organisateurs/1 or /organisateurs/1.json
  def destroy
    @organisateur.destroy

    respond_to do |format|
      format.html { redirect_to organisateurs_url, notice: "Organisateur was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organisateur
    @organisateur = Organisateur.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def organisateur_params
    params.require(:organisateur).permit(:user_id, :nom_organisme, :description_organisme)
  end
end
