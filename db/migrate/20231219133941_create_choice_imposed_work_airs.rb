class CreateChoiceImposedWorkAirs < ActiveRecord::Migration[7.0]
  def change
    create_table :choice_imposed_work_airs do |t|
      t.references :choice_imposed_work, null: false, foreign_key: true
      t.references :air, null: false, foreign_key: true

      t.timestamps
    end
  end
end
