class AddTitleToSemiImposedWork < ActiveRecord::Migration[7.0]
  def change
    add_column :semi_imposed_works, :title, :string
  end
end
