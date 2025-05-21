class AddNoPianistAccompagnateurToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :requires_pianist_accompanist, :boolean
  end
end
