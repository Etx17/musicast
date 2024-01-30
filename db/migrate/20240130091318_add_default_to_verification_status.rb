class AddDefaultToVerificationStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :inscription_item_requirements, :verification_status, 0
  end
end
