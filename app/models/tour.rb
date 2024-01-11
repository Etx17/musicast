class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy
end
