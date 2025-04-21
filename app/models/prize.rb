class Prize < ApplicationRecord
  belongs_to :category

  validates :title, :description, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0, less_than: 1000000}, allow_blank: true
  validates :other_reward, length: { maximum: 200 }, allow_blank: true
  validates :title, length: { minimum: 2, maximum: 100 }
  validates :description, length: { minimum: 2, maximum: 500 }

  enum :prize_type, { monetary: 0, non_monetary: 1, recognition: 2 }


end
