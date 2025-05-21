class AddRehearseTimeSlotPerCandidateToTours < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :rehearse_time_slot_per_candidate, :integer
  end
end
