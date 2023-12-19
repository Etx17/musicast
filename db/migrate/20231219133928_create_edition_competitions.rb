class CreateEditionCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :edition_competitions do |t|
      t.references :competition, null: false, foreign_key: true
      t.integer :annee
      t.text :details_specifiques

      t.timestamps
    end
  end
end
