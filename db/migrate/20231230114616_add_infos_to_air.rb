class AddInfosToAir < ActiveRecord::Migration[7.0]
  def change
    add_column :airs, :infos, :text
  end
end
