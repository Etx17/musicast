class AddDefaultValueToStateInInscriptionPaiements < ActiveRecord::Migration[7.0]
  def change
    change_column_default :inscription_paiements, :state, 0
  end
end
