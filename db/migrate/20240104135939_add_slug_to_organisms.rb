class AddSlugToOrganisms < ActiveRecord::Migration[7.0]
  def change
    add_column :organisms, :slug, :string
    add_index :organisms, :slug, unique: true
  end
end
