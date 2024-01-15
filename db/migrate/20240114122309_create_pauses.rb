class CreatePauses < ActiveRecord::Migration[7.0]
  def change
    create_table :pauses do |t|
      t.time :start_time
      t.time :end_time
      t.date :date
      t.references :tour, null: false, foreign_key: true

      t.timestamps
    end
  end
end
