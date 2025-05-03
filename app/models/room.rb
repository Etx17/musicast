class Room < ApplicationRecord
  belongs_to :organism
  has_many :rehearsals
end
