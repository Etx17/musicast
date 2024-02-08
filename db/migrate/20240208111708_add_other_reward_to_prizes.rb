class AddOtherRewardToPrizes < ActiveRecord::Migration[7.0]
  def change
    add_column :prizes, :other_reward, :string
  end
end
