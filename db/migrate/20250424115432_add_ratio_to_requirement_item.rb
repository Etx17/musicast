class AddRatioToRequirementItem < ActiveRecord::Migration[8.0]
  def change
    add_column :requirement_items, :ratio, :float, null: true
  end
end
