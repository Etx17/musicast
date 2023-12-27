class AddReferenceToFourTablesOfWorks < ActiveRecord::Migration[7.0]
  def change
    add_reference :imposed_works, :category, null: false, foreign_key: true
    add_reference :semi_imposed_works, :category, null: false, foreign_key: true
    add_reference :free_choices, :category, null: false, foreign_key: true
    add_reference :choice_imposed_works, :category, null: false, foreign_key: true
  end
end
