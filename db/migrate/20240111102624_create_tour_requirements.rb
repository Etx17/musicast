class CreateTourRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_requirements do |t|
      t.text :description
      t.integer :min_number_of_works
      t.integer :max_number_of_works
      t.integer :min_duration_minute
      t.integer :max_duration_minute
      t.references :tour, null: false, foreign_key: true
      t.boolean :organiser_creates_program

      t.timestamps
    end
  end
end
