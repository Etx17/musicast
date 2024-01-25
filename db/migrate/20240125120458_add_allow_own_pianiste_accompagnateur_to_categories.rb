class AddAllowOwnPianisteAccompagnateurToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :allow_own_pianist_accompagnateur, :boolean
  end
end
