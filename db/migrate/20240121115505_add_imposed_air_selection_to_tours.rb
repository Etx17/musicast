class AddImposedAirSelectionToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :imposed_air_selection, :text, array: true, default: []
  end
end
