class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  accepts_nested_attributes_for :tour_requirement
  accepts_nested_attributes_for :address
end
