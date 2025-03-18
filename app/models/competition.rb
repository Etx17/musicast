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
    organism.organisateur
  end

  def image_or_default
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    else
      "https://placehold.co/300x300"
    end
  end
end
