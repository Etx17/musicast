class CandidateRehearsalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_candidate_rehearsal, only: [:update_room]

  # POST /candidate_rehearsals/:id/update_room
  def update_room
    @rehearsal = CandidateRehearsal.find(params[:id])
    new_room_id = params[:room_id]

    if @rehearsal.update(room_id: new_room_id)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Salle modifiée avec succès.") }
        format.json { render json: { success: true, message: "Salle modifiée avec succès" } }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "Erreur lors de la modification de la salle: #{@rehearsal.errors.full_messages.join(', ')}") }
        format.json { render json: { success: false, errors: @rehearsal.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_candidate_rehearsal
    @candidate_rehearsal = CandidateRehearsal.find(params[:id])
  end
end
