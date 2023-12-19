class CreateCandidateProgramAirs < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_program_airs do |t|
      t.references :candidate_program, null: false, foreign_key: true
      t.references :air, null: false, foreign_key: true

      t.timestamps
    end
  end
end
