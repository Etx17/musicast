class AddPriceToInscription < ActiveRecord::Migration[7.0]
  def change
    add_monetize :inscriptions, :price, currency: { present: false }
  end
end
