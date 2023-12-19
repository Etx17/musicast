class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organism, null: false, foreign_key: true
      t.string :role_partenaire
      t.string :niveau_autorisation

      t.timestamps
    end
  end
end
