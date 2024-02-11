class CategoriesJury < ApplicationRecord
  belongs_to :category
  belongs_to :jury
end
