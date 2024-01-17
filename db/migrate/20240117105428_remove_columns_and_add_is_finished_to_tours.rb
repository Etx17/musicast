class RemoveColumnsAndAddIsFinishedToTours < ActiveRecord::Migration[7.0]
  def change
    remove_column :tours, :has_lunch_break, :boolean
    remove_column :tours, :lunch_start_time, :datetime
    remove_column :tours, :lunch_duration, :integer
    remove_column :tours, :has_morning_pause, :boolean
    remove_column :tours, :morning_pause_time, :datetime
    remove_column :tours, :has_afternoon_pause, :boolean
    remove_column :tours, :afternoon_pause_time, :datetime
    remove_column :tours, :morning_pause_duration_minutes, :integer
    remove_column :tours, :afternoon_pause_duration_minutes, :integer

    add_column :tours, :is_finished, :boolean, default: false
  end
end
