class AddIbanToCandidats < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :iban, :string
    add_index :candidats, :iban, unique: true
  end
end
