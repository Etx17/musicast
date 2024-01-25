class AddNoPianistAccompagnateurToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :no_pianist_accompagnateur, :boolean
  end
end
