class AddPianisteAccompagnateurToPerformances < ActiveRecord::Migration[7.0]
  def change
    add_reference :performances, :pianist_accompagnateur, null: true, foreign_key: true
  end
end
