class PianistAccompagnateursController < ApplicationController
  before_action :set_pianist, only: [:edit, :update, :destroy]

  def new
    @pianist = PianistAccompagnateur.new
  end

  def create
    @pianist = PianistAccompagnateur.new(pianist_params)
    if @pianist.save
      redirect_to @pianist, notice: 'Pianist was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @pianist.update(pianist_params)
      redirect_to @pianist, notice: 'Pianist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @pianist.destroy
    redirect_to organisateur_dashboard_path, notice: 'Pianist was successfully destroyed.'
  end

  private

  def set_pianist
    @pianist = PianistAccompagnateur.find(params[:id])
  end

  def pianist_params
    params.require(:pianist_accompagnateur).permit(:full_name)
  end
end
