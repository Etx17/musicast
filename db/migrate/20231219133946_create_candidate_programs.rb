class CreateCandidatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_programs do |t|
      t.references :inscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
