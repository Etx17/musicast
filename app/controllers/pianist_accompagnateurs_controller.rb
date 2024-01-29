class PianistAccompagnateursController < ApplicationController
  before_action :set_pianist, only: [:edit, :update, :destroy]

  def new
    @organism = Organism.friendly.find(params[:organism_id])
    @pianist = PianistAccompagnateur.new
  end

  def create
    @pianist = PianistAccompagnateur.new(pianist_params)
    @organism = Organism.friendly.find(params[:organism_id])
    @pianist.organism = @organism
    if @pianist.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('organism_pianists', partial: 'pianist', locals: { pianist: @pianist }),
          ]
        end
        format.html { redirect_to organisateur_dashboard_path, notice: 'Pianist was successfully created.' }
      end
    else
      render :new
    end
  end

  def edit
    @organism = Organism.friendly.find(params[:organism_id])
  end

  def update
    @pianist = PianistAccompagnateur.find(params[:id])
    @organism = @pianist.organism
    if @pianist.update(pianist_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("edit_pianist_frame_#{@pianist.id}", partial: 'pianist', locals: { pianist: @pianist })
        end
        format.html { redirect_to organisateur_dashboard_path, notice: 'Pianist was successfully created.' }
      end
    else
      render :edit
    end
  end

  def destroy
    @pianist.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("edit_pianist_frame_#{@pianist.id}") }
      format.html { redirect_to organisateur_dashboard_path, notice: 'Pianist was successfully destroyed.' }
    end
  end

  private

  def set_pianist
    @pianist = PianistAccompagnateur.find(params[:id])
  end

  def pianist_params
    params.require(:pianist_accompagnateur).permit(:full_name, :email, :phone_number, :organism_id)
  end
end
