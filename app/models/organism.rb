class Organism < ApplicationRecord
  has_many :competitions
  has_many :partners
  belongs_to :organisateur
end
