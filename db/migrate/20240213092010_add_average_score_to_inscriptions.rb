class AddAverageScoreToInscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :average_score, :float
  end
end
