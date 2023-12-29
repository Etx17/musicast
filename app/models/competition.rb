class Competition < ApplicationRecord
  has_many :edition_competitions
  belongs_to :organism

  has_many :documents, as: :parent, dependent: :destroy
  has_one_attached :photo

  def organisateur
    # returns the association organisateur of the competition
    organism.organisateur
  end
end
