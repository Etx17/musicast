class TourRequirement < ApplicationRecord
  belongs_to :tour

  validates :min_number_of_works, :max_number_of_works, numericality: { only_integer: true, greater_than: 0 }
  validates :min_number_of_works, :max_number_of_works, presence: true
  validates :min_number_of_works, comparison: { less_than_or_equal_to: :max_number_of_works, message: "must be less than the maximum number of works" }
end
