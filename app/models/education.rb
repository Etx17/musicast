class Education < ApplicationRecord
  belongs_to :candidat
  validates :title, :description, presence: true
  validates :title, length: { minimum: 2, maximum: 30 }
  validates :description, length: { minimum: 2, maximum: 300 }
end
