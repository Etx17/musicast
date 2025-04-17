class Experience < ApplicationRecord
  belongs_to :candidat
  validates :title, :start_date, :description, :english_title, :english_description, presence: true
  validates :title, length: { minimum: 2, maximum: 30 }
  validates :description, length: { minimum: 2, maximum: 300 }
  validates :english_title, length: { minimum: 2, maximum: 30 }
  validates :english_description, length: { minimum: 2, maximum: 300 }
  has_one_attached :logo, dependent: :destroy
end
