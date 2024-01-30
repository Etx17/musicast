class AddVerificationStatusToInscriptionItemRequirement < ActiveRecord::Migration[7.0]
  def change
    add_column :inscription_item_requirements, :verification_status, :integer
  end
end
