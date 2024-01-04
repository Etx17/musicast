class Inscription < ApplicationRecord
  has_many :performances
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category

  scope :by_category, -> (category_id) { where(category_id: category_id) }
  scope :by_candidat, -> (candidat_id) { where(candidat_id: candidat_id) }
end
