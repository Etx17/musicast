class Organism < ApplicationRecord
  has_many :competitions
  has_many :partners
  belongs_to :organisateur
  has_one :address, as: :addressable, dependent: :destroy

  extend FriendlyId
  friendly_id :nom, use: :slugged
end
