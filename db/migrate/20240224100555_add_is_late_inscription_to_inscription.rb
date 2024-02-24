class AddIsLateInscriptionToInscription < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :is_late_inscription, :boolean, default: false
  end
end
