class AddPaymentAfterApprovalToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :payment_after_approval, :boolean, default: false
    add_column :inscriptions, :payment_status, :integer, default: 0
  end
end
