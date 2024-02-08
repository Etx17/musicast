class Prize < ApplicationRecord
  belongs_to :category
  validates :title, :description, presence: true
  validates :amount, numericality: { greater_than: 0, less_than: 1000000}, allow_blank: true
  validates :other_reward, length: { maximum: 200 }, allow_blank: true
  validates :title, length: { minimum: 2, maximum: 100 }
  validates :description, length: { minimum: 2, maximum: 500 }

  # Les prix peuvent avoir un prix en argent, en nature, ou rien (reconnaissance)

end
