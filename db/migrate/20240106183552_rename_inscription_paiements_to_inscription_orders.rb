class RenameInscriptionPaiementsToInscriptionOrders < ActiveRecord::Migration[7.0]
  def change
    rename_table :inscription_paiements, :inscription_orders

  end
end
