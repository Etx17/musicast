class ChoiceImposedWork < ApplicationRecord
  has_many :airs, dependent: :destroy
  belongs_to :category
  accepts_nested_attributes_for :airs, allow_destroy: true
end
