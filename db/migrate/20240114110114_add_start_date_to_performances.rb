class AddStartDateToPerformances < ActiveRecord::Migration[7.0]
  def change
    add_column :performances, :start_date, :date
  end
end
