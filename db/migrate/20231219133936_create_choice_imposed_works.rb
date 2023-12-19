class CreateChoiceImposedWorks < ActiveRecord::Migration[7.0]
  def change
    create_table :choice_imposed_works do |t|
      t.references :programme_requirement, null: false, foreign_key: true
      t.string :title
      t.text :guidelines
      t.integer :number_to_select

      t.timestamps
    end
  end
end
