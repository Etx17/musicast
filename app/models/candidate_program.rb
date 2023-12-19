class CandidateProgram < ApplicationRecord
  has_many :candidate_program_airs
  has_many :airs, through: :candidate_program_airs
  belongs_to :inscription
end
