class EducationsController < ApplicationController
  def destroy
    @education = Education.find(params[:id])
    @candidat = @education.candidat
    if @education.destroy
      redirect_to candidat_path(@candidat), notice: "L'expérience a bien été supprimée"
    end
  end
end
