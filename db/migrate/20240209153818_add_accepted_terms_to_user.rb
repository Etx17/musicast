class AddAcceptedTermsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :accepted_terms, :boolean
    add_column :users, :terms_version, :integer, default: 0
  end
end
