class AddMinutesMaxPerPerformanceToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :minutes_max_per_performance, :integer
  end
end
