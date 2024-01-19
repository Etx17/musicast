class SemiImposedWorkAir < ApplicationRecord
  belongs_to :semi_imposed_work
  belongs_to :inscription
  belongs_to :air

  accepts_nested_attributes_for :air

end
