class AddChangesRequestedToInscription < ActiveRecord::Migration[8.0]
  def change
    add_column :inscriptions, :changes_requested, :text, default: ""
  end
end
