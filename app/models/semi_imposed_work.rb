class SemiImposedWork < ApplicationRecord
  has_many :airs
  belongs_to :category
end
