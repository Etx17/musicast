# app/models/candidate_rehearsal.rb
class CandidateRehearsal < ApplicationRecord
  belongs_to :room
  belongs_to :tour
  belongs_to :candidat
  belongs_to :pianist_accompagnateur, optional: true

  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :within_room_availability
  validate :no_overlapping_rehearsals
  validate :no_pianist_conflicts

  before_validation :set_end_time_from_duration, if: -> { end_time.nil? && start_time.present? && tour.present? }

  private

  def end_time_after_start_time
    if start_time && end_time && end_time <= start_time
      errors.add(:end_time, "doit être après l'heure de début")
    end
  end

  def within_room_availability
    if room && start_time && end_time
      unless start_time.strftime("%H:%M") >= room.start_time.strftime("%H:%M") &&
             end_time.strftime("%H:%M") <= room.end_time.strftime("%H:%M")
        errors.add(:base, "La répétition doit être dans les heures d'ouverture de la salle")
      end
    end
  end

  def no_overlapping_rehearsals
    # Vérifie qu'il n'y a pas de chevauchement avec d'autres répétitions dans la même salle
    if room_id && start_time && end_time
      overlaps = CandidateRehearsal.where(room_id: room_id)
                                  .where.not(id: id)
                                  .where("(start_time < ? AND end_time > ?) OR
                                         (start_time < ? AND end_time > ?) OR
                                         (start_time >= ? AND end_time <= ?)",
                                         end_time, start_time,
                                         end_time, start_time,
                                         start_time, end_time)
      if overlaps.exists?
        errors.add(:base, "Ce créneau chevauche une autre répétition dans cette salle")
      end
    end
  end

  def no_pianist_conflicts
    # Vérifie que le pianiste n'est pas déjà assigné à une autre répétition au même moment
    if pianist_accompagnateur_id && start_time && end_time
      overlaps = CandidateRehearsal.where(pianist_accompagnateur_id: pianist_accompagnateur_id)
                                  .where.not(id: id)
                                  .where("(start_time < ? AND end_time > ?) OR
                                         (start_time < ? AND end_time > ?) OR
                                         (start_time >= ? AND end_time <= ?)",
                                         end_time, start_time,
                                         end_time, start_time,
                                         start_time, end_time)
      if overlaps.exists?
        errors.add(:base, "Le pianiste accompagnateur est déjà assigné à une autre répétition à ce moment")
      end
    end
  end

  def set_end_time_from_duration
    if tour.rehearse_time_slot_per_candidate.present?
      self.end_time = start_time + tour.rehearse_time_slot_per_candidate.minutes
    end
  end
end
