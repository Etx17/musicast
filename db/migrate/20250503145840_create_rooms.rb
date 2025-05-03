class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.timestamps
      t.string :name
      t.string :notes
      t.references :organism, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.text :description
      t.text :description_english
    end
  end
end
