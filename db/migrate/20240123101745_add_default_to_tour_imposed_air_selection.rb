class AddDefaultToTourImposedAirSelection < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tours, :imposed_air_selection, from: nil, to: []
  end
end
