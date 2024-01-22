class AddOrderedAirSelectionOnPerformance < ActiveRecord::Migration[7.0]
  def change
    add_column :performances, :ordered_air_selection, :text, array: true, default: []
  end
end
