class Competition < ApplicationRecord
  has_many :edition_competitions
  belongs_to :organism

  def organisateur
    # returns the association organisateur of the competition
    organism.organisateur
  end
end
