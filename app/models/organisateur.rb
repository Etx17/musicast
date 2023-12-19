class Organisateur < ApplicationRecord
  has_many :organisms
  belongs_to :user
end
