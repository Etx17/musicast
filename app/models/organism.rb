class Organism < ApplicationRecord
  has_many :competitions
  has_many :partners
  belongs_to :organisateur
  has_one :address, as: :addressable, dependent: :destroy
  has_many :pianist_accompagnateurs

  has_many :edition_competitions, through: :competitions
  extend FriendlyId
  friendly_id :nom, use: :slugged

  before_save :should_generate_new_friendly_id?
  before_update :should_generate_new_friendly_id?
  has_one_attached :logo

  validates :nom, presence: true

  def should_generate_new_friendly_id?
    self.slug = nom.parameterize if nom_changed?
  end
end
