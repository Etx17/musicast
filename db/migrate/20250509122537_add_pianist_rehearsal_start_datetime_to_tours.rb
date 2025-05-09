class AddPianistRehearsalStartDatetimeToTours < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :pianist_rehearsal_start_datetime, :datetime
  end
end
