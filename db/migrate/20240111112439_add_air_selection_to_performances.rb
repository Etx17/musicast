class AddAirSelectionToPerformances < ActiveRecord::Migration[7.0]
  def change
    add_column :performances, :air_selection, :text, array: true, default: []
  end
end
