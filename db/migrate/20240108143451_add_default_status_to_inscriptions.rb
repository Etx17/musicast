class AddDefaultStatusToInscriptions < ActiveRecord::Migration[7.0]
  def change
    if column_exists?(:inscriptions, :statut)
      rename_column :inscriptions, :statut, :status
    end
    change_column_default :inscriptions, :status, from: nil, to: 0
  end
end
