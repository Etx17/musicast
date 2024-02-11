class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.integer :jury_id
      t.integer :inscription_id
      t.integer :note_value

      t.timestamps
    end
  end
end
