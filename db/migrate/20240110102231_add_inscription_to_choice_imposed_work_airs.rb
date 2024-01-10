class AddInscriptionToChoiceImposedWorkAirs < ActiveRecord::Migration[7.0]
  def change
    add_reference :choice_imposed_work_airs, :inscription, null: false, foreign_key: true
  end
end
