class CreateCandidateRehearsals < ActiveRecord::Migration[8.0]
  def change
    create_table :candidate_rehearsals do |t|
      t.references :room, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true
      t.references :candidat, null: false, foreign_key: true
      t.references :pianist_accompagnateur, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :confirmed, default: false
      t.text :notes

      t.timestamps
    end
    # Ajout d'un index pour éviter les doubles réservations
    add_index :candidate_rehearsals, [:room_id, :start_time, :end_time], unique: true, name: 'index_candidate_rehearsals_on_room_and_time'
    add_index :candidate_rehearsals, [:candidat_id, :tour_id], unique: true, name: 'index_candidate_rehearsals_on_candidate_and_tour'

  end
end
