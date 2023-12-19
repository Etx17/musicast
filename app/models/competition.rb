class Competition < ApplicationRecord
  has_many :edition_competitions
  belongs_to :organism
end
