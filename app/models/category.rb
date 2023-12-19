class Category < ApplicationRecord
  has_many :tours
  has_many :requirement_items
  has_many :inscriptions
  has_one :programme_requirement
  belongs_to :edition_competition
end
