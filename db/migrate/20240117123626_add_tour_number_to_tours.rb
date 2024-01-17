class AddTourNumberToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :tour_number, :integer, default: 1
  end
end
