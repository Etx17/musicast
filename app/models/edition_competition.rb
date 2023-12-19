class EditionCompetition < ApplicationRecord
  has_many :categories
  belongs_to :competition
end
