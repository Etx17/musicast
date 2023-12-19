class Performance < ApplicationRecord
  has_many :tour
  belongs_to :inscription
  belongs_to :tour
end
