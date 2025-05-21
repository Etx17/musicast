class AddCandidateBringsPianistAccompagnateurEmail < ActiveRecord::Migration[8.0]
  def change
    add_column :inscriptions, :candidate_brings_pianist_accompagnateur_email, :string
    add_column :inscriptions, :candidate_brings_pianist_accompagnateur_full_name, :string
  end
end
