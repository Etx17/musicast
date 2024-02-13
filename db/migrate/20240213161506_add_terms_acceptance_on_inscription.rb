class AddTermsAcceptanceOnInscription < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :terms_accepted, :boolean, default: false
  end
end
