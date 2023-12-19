class Inscription < ApplicationRecord
  has_many :performances
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category
end
