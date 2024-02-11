class CreateOrganismJuries < ActiveRecord::Migration[7.0]
  def change
    create_table :organism_juries do |t|
      t.references :organism, null: false, foreign_key: true
      t.references :jury, null: false, foreign_key: true

      t.timestamps
    end
  end
end
