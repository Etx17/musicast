class Note < ApplicationRecord
  belongs_to :jury
  belongs_to :inscription

  validates :note_value, presence: true
  validates :note_value, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  validates :details, length: { maximum: 500 }

  after_save :update_inscription_average_score
  after_destroy :update_inscription_average_score
  after_update :update_inscription_average_score

  def update_inscription_average_score
    inscription.update_average_score
  end
end
