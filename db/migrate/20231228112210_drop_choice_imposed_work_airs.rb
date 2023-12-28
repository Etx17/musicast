class DropChoiceImposedWorkAirs < ActiveRecord::Migration[7.0]
  def up
    drop_table :choice_imposed_work_airs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
