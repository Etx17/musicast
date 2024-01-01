class SemiImposedWork < ApplicationRecord
  has_many :airs, dependent: :destroy
  belongs_to :category
end
