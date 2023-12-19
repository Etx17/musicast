class ImposedWork < ApplicationRecord
  has_many :imposed_work_airs
  has_many :airs, through: :imposed_work_airs
  belongs_to :programme_requirement
end
