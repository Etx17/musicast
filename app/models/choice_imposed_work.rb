class ChoiceImposedWork < ApplicationRecord

  has_many :choice_imposed_work_airs, dependent: :destroy
  has_many :airs, through: :choice_imposed_work_airs
  has_many :airs, dependent: :destroy

  accepts_nested_attributes_for :choice_imposed_work_airs, allow_destroy: true
  accepts_nested_attributes_for :airs, allow_destroy: true
  belongs_to :category

end
