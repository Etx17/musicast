class ModifyTourNoPianistAccompagnateurIntoRequiresPianistAccompanist < ActiveRecord::Migration[8.0]
  def change
    rename_column :tours, :no_pianist_accompagnateur, :requires_pianist_accompanist
    change_column :tours, :requires_pianist_accompanist, :boolean, default: true
  end
end
