class Organism < ApplicationRecord
  has_many :competitions
  has_many :partners
  belongs_to :organisateur
  has_one :address, as: :addressable, dependent: :destroy
  has_many :pianist_accompagnateurs
  has_many :edition_competitions, through: :competitions
  has_many :organism_juries
  has_many :juries, through: :organism_juries

  extend FriendlyId
  friendly_id :nom, use: :slugged

  before_save :should_generate_new_friendly_id?
  before_update :should_generate_new_friendly_id?
  has_one_attached :logo

  validates :nom, :description, presence: true
  validates :nom, length: { minimum: 2, maximum: 50 }
  validates :description, length: { minimum: 2, maximum: 1000 }

  def should_generate_new_friendly_id?
    self.slug = nom.parameterize if nom_changed?
  end

  def logo_or_default
    if logo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(logo, only_path: true)
    else
      "https://placehold.co/40x40"
    end
  end
end
