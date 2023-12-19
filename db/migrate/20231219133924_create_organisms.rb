class CreateOrganisms < ActiveRecord::Migration[7.0]
  def change
    create_table :organisms do |t|
      t.references :organisateur, null: false, foreign_key: true
      t.string :nom
      t.text :description

      t.timestamps
    end
  end
end
