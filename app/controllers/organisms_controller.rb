class OrganismsController < ApplicationController
  before_action :set_organism, only: %i[show edit update destroy]

  # GET /organisms or /organisms.json
  def index
    @organisms = Organism.all
  end

  # GET /organisms/1 or /organisms/1.json
  def show
    authorize @organism
  end


  # GET /organisms/new
  def new
    @organism = Organism.new
    @organisateur = current_user.organisateur
  end

  # GET /organisms/1/edit
  def edit
    authorize @organism
  end

  # POST /organisms or /organisms.json
  def create
    @organism = Organism.new(organism_params)
    @organism.organisateur = current_user.organisateur

    authorize @organism
    if @organism.save
      redirect_to organisateur_dashboard_path, notice: "Votre organisme a été crée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organisms/1 or /organisms/1.json
  def update
    authorize @organism
    if @organism.update(organism_params)
      redirect_to organisateur_dashboard_path, notice: "Votre organisme a été modifié avec succès."
    else
      render :edit
    end
  end

  # DELETE /organisms/1 or /organisms/1.json
  def destroy
    authorize @organism
    @organism.destroy

    respond_to do |format|
      format.html { redirect_to organisms_url, notice: "Organism was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organism
    @organism = Organism.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def organism_params
    params.require(:organism).permit(:organisateur_id, :nom, :description, :photo, :address_id, :logo)
  end
end
