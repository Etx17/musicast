class ExperiencesController < ApplicationController

  def destroy
    @experience = Experience.find(params[:id])
    @candidat = @experience.candidat
    if @experience.destroy
      redirect_to candidat_path(@candidat), notice: "L'expérience a bien été supprimée"
    end
  end
end
