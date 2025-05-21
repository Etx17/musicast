class AddPaymentGuidelinesAndPaymentGuidelinesEnglishToCategory < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :payment_guidelines, :text
    add_column :categories, :payment_guidelines_english, :text
  end
end
