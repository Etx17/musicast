class AddCandidateRehearsalToPerformances < ActiveRecord::Migration[8.0]
  def change
    add_reference :candidate_rehearsals, :performance, foreign_key: true
  end
end
