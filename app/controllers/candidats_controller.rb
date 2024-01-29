class CandidatsController < ApplicationController
  before_action :set_candidat, only: %i[show edit update destroy]

  # GET /candidats or /candidats.json
  def index
    @candidats = Candidat.all
  end

  # GET /candidats/1 or /candidats/1.json
  def show
    @candidat = Candidat.find(params[:id])
  end

  # GET /candidats/new
  def new
    @candidat = Candidat.new
  end

  # GET /candidats/1/edit
  def edit

  end

  # POST /candidats or /candidats.json
  def create
    @candidat = Candidat.new(candidat_params)

    respond_to do |format|
      if @candidat.save
        format.html { redirect_to candidat_url(@candidat), notice: "Candidat was successfully created." }
        format.json { render :show, status: :created, location: @candidat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @candidat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidats/1 or /candidats/1.json
  def update
    respond_to do |format|
      if @candidat.update(candidat_params)
        format.html { redirect_to candidat_url(@candidat), notice: "Candidat was successfully updated." }
        format.json { render :show, status: :ok, location: @candidat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @candidat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidats/1 or /candidats/1.json
  def destroy
    @candidat.destroy

    respond_to do |format|
      format.html { redirect_to candidats_url, notice: "Candidat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_diploma
    @candidat = Candidat.find(params[:id])
    @candidat.diplomas.attach(params[:candidat][:new_diploma])
    redirect_to @candidat
  end

  def delete_diploma
    @candidat = Candidat.find(params[:id])
    diploma = @candidat.diplomas.find(params[:diploma_id])
    diploma.purge
    redirect_to candidat_path(@candidat), notice: "Diplôme supprimé"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidat
    @candidat = Candidat.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def candidat_params
    params.require(:candidat).permit(:user_id, :nationality,
    :artistic_photo,
    :first_name, :last_name, :birthdate, :bio, :short_bio, :medium_bio, :long_bio, :repertoire, :banner, :portrait,
    experiences_attributes: [:id, :title, :company, :location, :start_date, :end_date, :description, :_destroy],
    educations_attributes: [:id, :title, :organism, :location, :start_date, :end_date, :description, :_destroy],
    diplomas: []
    )
  end
end
