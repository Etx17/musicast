class CreateOrganisateurs < ActiveRecord::Migration[7.0]
  def change
    create_table :organisateurs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nom_organisme
      t.text :description_organisme

      t.timestamps
    end
  end
end
