class Competition < ApplicationRecord
  has_many :edition_competitions
  belongs_to :organism

  has_many :documents, as: :parent, dependent: :destroy
  
  def organisateur
    # returns the association organisateur of the competition
    organism.organisateur
  end
end
