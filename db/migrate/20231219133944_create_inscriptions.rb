class CreateInscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :inscriptions do |t|
      t.references :candidat, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :statut

      t.timestamps
    end
  end
end
