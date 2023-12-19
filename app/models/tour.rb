class Tour < ApplicationRecord
  has_many :programme_requirements
  has_many :performances
  belongs_to :category
end
