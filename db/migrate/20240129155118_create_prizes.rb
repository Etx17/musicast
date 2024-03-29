class CreatePrizes < ActiveRecord::Migration[7.0]
  def change
    create_table :prizes do |t|
      t.string :title
      t.integer :amount
      t.text :description
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
