class AddTimePreferenceToInscription < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :time_preference, :integer, default: 0
  end
end
