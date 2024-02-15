class AddDefaultAmountValueToPrize < ActiveRecord::Migration[7.0]
  def change
    change_column_default :prizes, :amount, 0
  end
end
