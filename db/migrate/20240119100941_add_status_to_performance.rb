class AddStatusToPerformance < ActiveRecord::Migration[7.0]
  def change
    add_column :performances, :status, :integer, default: 0
  end
end
