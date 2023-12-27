class ChoiceImposedWork < ApplicationRecord
  has_many :choice_imposed_work_airs
  has_many :airs, through: :choice_imposed_work_airs
  belongs_to :category
end
