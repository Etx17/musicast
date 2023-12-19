class CreateFreeChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :free_choices do |t|
      t.references :programme_requirement, null: false, foreign_key: true
      t.integer :number
      t.integer :max_length_minutes

      t.timestamps
    end
  end
end
