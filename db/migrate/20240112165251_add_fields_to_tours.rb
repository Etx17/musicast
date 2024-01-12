class AddFieldsToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :max_end_of_day_time, :datetime
    add_column :tours, :new_day_start_time, :datetime
    add_column :tours, :has_lunch_break, :boolean
    add_column :tours, :lunch_start_time, :datetime
    add_column :tours, :lunch_duration, :integer
    add_column :tours, :has_morning_pause, :boolean
    add_column :tours, :morning_pause_time, :datetime
    add_column :tours, :has_afternoon_pause, :boolean
    add_column :tours, :afternoon_pause_time, :datetime
    add_column :tours, :morning_pause_duration_minutes, :integer
    add_column :tours, :afternoon_pause_duration_minutes, :integer
  end
end
