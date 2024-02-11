class AddDetailsToJuries < ActiveRecord::Migration[7.0]
  def change
    add_column :juries, :first_name, :string
    add_column :juries, :last_name, :string
    add_column :juries, :email, :string
    add_column :juries, :short_bio, :text
  end
end
