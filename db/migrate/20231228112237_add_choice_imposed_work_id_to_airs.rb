class AddChoiceImposedWorkIdToAirs < ActiveRecord::Migration[7.0]
  def change
    add_reference :airs, :choice_imposed_work, null: true, foreign_key: true
  end
end
