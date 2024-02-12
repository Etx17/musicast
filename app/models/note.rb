class Note < ApplicationRecord
  belongs_to :jury
  belongs_to :inscription

  validates :note_value, presence: true
  validates :note_value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :details, length: { maximum: 500 }
end
