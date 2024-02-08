class SemiImposedWork < ApplicationRecord
  has_many :airs, dependent: :destroy
  accepts_nested_attributes_for :airs, allow_destroy: true
  belongs_to :category

  has_many :semi_imposed_work_airs, dependent: :destroy
  has_many :airs, through: :semi_imposed_work_airs
  accepts_nested_attributes_for :semi_imposed_work_airs, allow_destroy: true

  validates :title, :guidelines, :number, :max_length_minutes, presence: true
  validates :number, :max_length_minutes, numericality: { only_integer: true, greater_than: 0 }
  validates :title, length: { minimum: 2, maximum: 100 }
  validates :guidelines, length: { minimum: 2, maximum: 500 }


end
