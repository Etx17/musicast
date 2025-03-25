class AddTitleEnglishToRequirementItem < ActiveRecord::Migration[8.0]
  def change
    add_column :requirement_items, :title_english, :string
  end
end
