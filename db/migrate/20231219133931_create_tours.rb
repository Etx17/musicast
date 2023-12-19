class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.references :category, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :start_time
      t.datetime :end_date
      t.datetime :end_time
      t.boolean :is_online
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
