class AddIbanToOrganism < ActiveRecord::Migration[8.0]
  def change
    add_column :organisms, :iban, :string
  end
end
