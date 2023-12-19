class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.references :edition_competition, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :min_age
      t.integer :max_age
      t.integer :discipline

      t.timestamps
    end
  end
end
