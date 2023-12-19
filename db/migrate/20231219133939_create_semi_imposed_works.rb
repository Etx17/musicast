class CreateSemiImposedWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :semi_imposed_works do |t|
      t.references :programme_requirement, null: false, foreign_key: true
      t.text :guidelines
      t.integer :number
      t.integer :max_length_minutes

      t.timestamps
    end
  end
end
