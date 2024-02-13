class OrganismJuriesController < ApplicationController
  before_action :set_organism, only: [:new, :create, :destroy]

  def new
    @organism_jury = OrganismJury.new
  end

  def create
    @organism_jury = OrganismJury.new(organism_jury_params)
    @organism_jury.organism = @organism

    if @organism_jury.save
      redirect_to organisateur_dashboard_path, notice: 'Jury was successfully associated.'
    else
      redirect_to organisateur_dashboard_path, notice: "Erreur lors de l'association du jury. Vérifiez qu'il n'est pas déjà associé à cet organisme."
    end
  end

  def destroy
    @organism_jury = OrganismJury.find(params[:id])
    @organism_jury.destroy
    redirect_to organisateur_dashboard_path, notice: 'Ce membre a bien été retiré de votre organisme'
  end

  private

  def set_organism
    @organism = Organism.friendly.find(params[:organism_id])
  end

  def organism_jury_params
    params.require(:organism_jury).permit(:jury_id, :organism_id)
  end
end
