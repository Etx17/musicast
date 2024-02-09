class AddAcceptsNewsletterToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :accepts_newsletter, :boolean, default: :false
  end
end
