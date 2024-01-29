class ChangeTypeItemInRequirementItems < ActiveRecord::Migration[7.0]
    def up
      change_column :requirement_items, :type_item, 'integer USING CAST(type_item AS integer)'
    end

    def down
      change_column :requirement_items, :type_item, :string
    end
end
