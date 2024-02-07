class Competition < ApplicationRecord
  has_one_attached :photo
  has_many :edition_competitions, dependent: :destroy
  belongs_to :organism
  has_many :documents, as: :parent, dependent: :destroy

  extend FriendlyId
  friendly_id :nom_concours, use: :slugged

  validates :nom_concours, presence: true
  validates :description, presence: true

  validates :nom_concours, length: { minimum: 3, maximum: 200 }
  validates :description, length: { minimum: 3, maximum: 500 }

  def organisateur
    # returns the association organisateur of the competition
    organism.organisateur
  end
end
