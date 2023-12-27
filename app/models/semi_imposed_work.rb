class SemiImposedWork < ApplicationRecord
  has_many :semi_imposed_work_airs
  has_many :airs, through: :semi_imposed_work_airs
  belongs_to :category
end
