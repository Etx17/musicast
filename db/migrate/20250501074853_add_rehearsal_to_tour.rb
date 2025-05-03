class AddRehearsalToTour < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :needs_rehearsal, :boolean, default: false
    add_column :tours, :rehearsal_type, :integer, default: 0
  end
end
