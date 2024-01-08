class AddPriceToCategories < ActiveRecord::Migration[7.0]
  def change
    add_monetize :categories, :price
  end
end
