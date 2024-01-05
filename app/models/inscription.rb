class Inscription < ApplicationRecord
  has_many :performances
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category

  has_many :inscription_item_requirements
  accepts_nested_attributes_for :inscription_item_requirements, allow_destroy: true


  scope :by_category, -> (category_id) { where(category_id: category_id) }
  scope :by_candidat, -> (candidat_id) { where(candidat_id: candidat_id) }

  enum status: {
    draft: 0,
    paid: 1,
    accepted: 2,
    rejected: 3
  }
end
