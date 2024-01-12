class AddFirstNameToCandidate < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :first_name, :string
  end
end
