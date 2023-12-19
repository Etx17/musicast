class CreatePerformances < ActiveRecord::Migration[7.0]
  def change
    create_table :performances do |t|
      t.references :inscription, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true
      t.datetime :heure_performance
      t.text :resultat

      t.timestamps
    end
  end
end
