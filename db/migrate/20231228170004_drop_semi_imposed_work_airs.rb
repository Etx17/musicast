class DropSemiImposedWorkAirs < ActiveRecord::Migration[7.0]
  def up
    drop_table :semi_imposed_work_airs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
