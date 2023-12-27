class FreeChoiceAir < ApplicationRecord
  belongs_to :category
  belongs_to :free_choice
  belongs_to :air
end
