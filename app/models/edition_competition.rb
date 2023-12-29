class EditionCompetition < ApplicationRecord
  has_many :categories
  belongs_to :competition
  has_one_attached :photo
end
