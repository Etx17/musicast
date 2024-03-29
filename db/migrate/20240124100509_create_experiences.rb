class CreateExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :experiences do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.text :description
      t.references :candidat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
