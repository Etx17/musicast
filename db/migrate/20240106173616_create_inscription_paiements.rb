class CreateInscriptionPaiements < ActiveRecord::Migration[7.0]
  def change
    create_table :inscription_paiements do |t|
      t.integer :state
      t.string :checkout_session_id
      t.references :user, null: false, foreign_key: true
      t.references :inscription, null: false, foreign_key: true

      t.timestamps
    end

    add_monetize :inscription_paiements, :amount
  end
end
