class CreateRequirementItems < ActiveRecord::Migration[7.0]
  def change
    create_table :requirement_items do |t|
      t.references :category, null: false, foreign_key: true
      t.string :type_item
      t.text :description_item
      t.string :title

      t.timestamps
    end
  end
end
