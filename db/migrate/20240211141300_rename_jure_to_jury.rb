class RenameJureToJury < ActiveRecord::Migration[7.0]
  def change
    rename_table :jures, :juries
  end
end
