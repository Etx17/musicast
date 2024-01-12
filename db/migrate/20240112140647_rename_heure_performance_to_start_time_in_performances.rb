class RenameHeurePerformanceToStartTimeInPerformances < ActiveRecord::Migration[7.0]
  def change
    rename_column :performances, :heure_performance, :start_time
  end
end
