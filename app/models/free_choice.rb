class FreeChoice < ApplicationRecord
  has_many :free_choice_airs, dependent: :destroy
  has_many :airs, through: :free_choice_airs
  belongs_to :category
end
