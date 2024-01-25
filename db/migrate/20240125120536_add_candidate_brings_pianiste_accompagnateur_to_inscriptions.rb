class AddCandidateBringsPianisteAccompagnateurToInscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :candidate_brings_pianist_accompagnateur, :boolean
  end
end
