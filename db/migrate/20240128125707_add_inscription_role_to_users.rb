class AddInscriptionRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :inscription_role, :integer, default: 0
  end
end
