class CreateFreeChoiceAirs < ActiveRecord::Migration[7.0]
  def change
    create_table :free_choice_airs do |t|
      t.references :free_choice, null: false, foreign_key: true
      t.references :air, null: false, foreign_key: true

      t.timestamps
    end
  end
end
