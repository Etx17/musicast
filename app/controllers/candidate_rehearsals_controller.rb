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

  # POST /candidate_rehearsals/:id/move_up
  def move_up
    @rehearsal = CandidateRehearsal.find(params[:id])
    room_id = @rehearsal.room_id
    pianist_id = @rehearsal.pianist_accompagnateur_id
    current_time = @rehearsal.start_time

    # Find the previous rehearsal in the same room with the same pianist
    previous_rehearsal = CandidateRehearsal.where(room_id: room_id, pianist_accompagnateur_id: pianist_id)
                                          .where("start_time < ?", current_time)
                                          .order(start_time: :desc)
                                          .first

    if previous_rehearsal
      # Store the times
      current_start = @rehearsal.start_time
      current_end = @rehearsal.end_time
      prev_start = previous_rehearsal.start_time
      prev_end = previous_rehearsal.end_time

      # Use a temporary time to avoid unique constraint violation
      temp_start = Time.new(2000, 1, 1, 0, 0, 0)
      temp_end = Time.new(2000, 1, 1, 1, 0, 0)

      # Update both rehearsals in a transaction with temporary values first
      ActiveRecord::Base.transaction do
        # First move current rehearsal to a temporary time
        @rehearsal.update!(start_time: temp_start, end_time: temp_end)

        # Then move previous rehearsal to current's time
        previous_rehearsal.update!(start_time: current_start, end_time: current_end)

        # Finally move current rehearsal to previous' time
        @rehearsal.update!(start_time: prev_start, end_time: prev_end)
      end

      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Ordre des répétitions modifié avec succès.", anchor: "rehearsal") }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "Impossible de déplacer cette répétition plus haut.", anchor: "rehearsal") }
        format.json { render json: { success: false, message: "Impossible de déplacer cette répétition plus haut." }, status: :unprocessable_entity }
      end
    end
  end

  # POST /candidate_rehearsals/:id/move_down
  def move_down
    @rehearsal = CandidateRehearsal.find(params[:id])
    room_id = @rehearsal.room_id
    pianist_id = @rehearsal.pianist_accompagnateur_id
    current_time = @rehearsal.start_time

    # Find the next rehearsal in the same room with the same pianist
    next_rehearsal = CandidateRehearsal.where(room_id: room_id, pianist_accompagnateur_id: pianist_id)
                                      .where("start_time > ?", current_time)
                                      .order(start_time: :asc)
                                      .first

    if next_rehearsal
      # Store the times
      current_start = @rehearsal.start_time
      current_end = @rehearsal.end_time
      next_start = next_rehearsal.start_time
      next_end = next_rehearsal.end_time

      # Use a temporary time to avoid unique constraint violation
      temp_start = Time.new(2000, 1, 1, 0, 0, 0)
      temp_end = Time.new(2000, 1, 1, 1, 0, 0)

      # Update both rehearsals in a transaction with temporary values first
      ActiveRecord::Base.transaction do
        # First move current rehearsal to a temporary time
        @rehearsal.update!(start_time: temp_start, end_time: temp_end)

        # Then move next rehearsal to current's time
        next_rehearsal.update!(start_time: current_start, end_time: current_end)

        # Finally move current rehearsal to next's time
        @rehearsal.update!(start_time: next_start, end_time: next_end)
      end

      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Ordre des répétitions modifié avec succès.", anchor: "rehearsal") }
        format.json { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "Impossible de déplacer cette répétition plus bas.", anchor: "rehearsal") }
        format.json { render json: { success: false, message: "Impossible de déplacer cette répétition plus bas." }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_candidate_rehearsal
    @candidate_rehearsal = CandidateRehearsal.find(params[:id])
  end
end
