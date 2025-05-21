class AddProgramConfigurationsOnCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :includes_semi_imposed_works, :boolean, default: false
    add_column :categories, :includes_imposed_works, :boolean, default: false
    add_column :categories, :includes_free_choices, :boolean, default: false
  end
end
