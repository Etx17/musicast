class RenameTrainingsToEducations < ActiveRecord::Migration[7.0]
  def change
    rename_table :trainings, :educations
  end
end
