class AddIsQualifiedOnPerformance < ActiveRecord::Migration[7.0]
  def change
    add_column :performances, :is_qualified, :boolean, default: false
  end
end
