class SemiImposedWork < ApplicationRecord
  has_many :airs, dependent: :destroy
  accepts_nested_attributes_for :airs, allow_destroy: true
  belongs_to :category

  has_many :semi_imposed_work_airs, dependent: :destroy
  has_many :airs, through: :semi_imposed_work_airs
  accepts_nested_attributes_for :semi_imposed_work_airs, allow_destroy: true
end
