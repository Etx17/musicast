class AddRequiresOrchestraToTours < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :requires_orchestra, :boolean, default: false
  end
end
