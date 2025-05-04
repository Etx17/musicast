class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organism
  before_action :set_room, only: [:edit, :update, :destroy]

  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = @organism.rooms.build
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /rooms/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /rooms or /rooms.json
  def create
    @room = @organism.rooms.build(room_params)

    if @room.save
      redirect_to organisateur_dashboard_path, notice: "Salle créée avec succès."
    else
      # Rendre le formulaire avec erreurs
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    if @room.update(room_params)
      redirect_to dashboard_organiser_path, notice: "Salle mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy
    redirect_to dashboard_organiser_path, notice: "Salle supprimée avec succès."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organism
      @organism = Organism.friendly.find(params[:organism_id])
    end

    def set_room
      @room = @organism.rooms.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:name, :notes, :organism_id, :start_time, :end_time, :description, :description_english)
    end
end
