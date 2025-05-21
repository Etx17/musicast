class AddDpiToInscriptionItemRequirements < ActiveRecord::Migration[7.0]
  def change
    add_column :inscription_item_requirements, :dpi_x, :integer
    add_column :inscription_item_requirements, :dpi_y, :integer
  end
end
