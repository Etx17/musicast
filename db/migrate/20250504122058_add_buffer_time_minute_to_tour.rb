class AddBufferTimeMinuteToTour < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :buffer_time_minutes, :integer, default: 0
  end
end
