class AddIncludesChoiceImposedWorksToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :includes_choice_imposed_works, :boolean, default: false
  end
end
