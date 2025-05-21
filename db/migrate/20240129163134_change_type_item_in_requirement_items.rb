class ChangeTypeItemInRequirementItems < ActiveRecord::Migration[7.0]
  def change
    change_column :requirement_items, :type_item, :integer, using: 'type_item::integer'
  end
end
