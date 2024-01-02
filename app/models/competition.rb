class Competition < ApplicationRecord
  has_one_attached :photo
  has_many :edition_competitions, dependent: :destroy
  belongs_to :organism

  has_many :documents, as: :parent, dependent: :destroy

  def organisateur
    # returns the association organisateur of the competition
    organism.organisateur
  end
end
