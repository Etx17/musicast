class AddImposedWorkToAirs < ActiveRecord::Migration[7.0]
  def change
    add_reference :airs, :imposed_work, null: true, foreign_key: true
  end
end
