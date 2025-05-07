class AddAcceptPlatformTermsToInscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :inscriptions, :accept_platform_terms, :boolean, default: false
  end
end
