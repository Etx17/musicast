class Room < ApplicationRecord
  belongs_to :organism
  has_many :rehearsals
  has_and_belongs_to_many :tours

  validates :name, :start_time, :end_time, presence: true
  validates :name, uniqueness: { scope: :organism_id }
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    if start_time && end_time && end_time <= start_time
      errors.add(:end_time, "doit être après l'heure de début")
    end
  end
end
