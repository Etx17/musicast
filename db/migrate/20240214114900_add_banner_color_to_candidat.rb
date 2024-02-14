class AddBannerColorToCandidat < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :banner_color, :string
  end
end
