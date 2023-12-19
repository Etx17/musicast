class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions do |t|
      t.references :organism, null: false, foreign_key: true
      t.string :nom_concours
      t.text :description

      t.timestamps
    end
  end
end
