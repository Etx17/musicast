class CreateCategoriesJuries < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_juries do |t|
      t.references :category, null: false, foreign_key: true
      t.references :jury, null: false, foreign_key: true

      t.timestamps
    end
  end
end
