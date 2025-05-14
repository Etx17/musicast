class AddIsQualifiedForCurrentTourToPerformance < ActiveRecord::Migration[8.0]
  def change
    add_column :performances, :is_qualified_for_current_tour, :boolean, default: false
  end
end
