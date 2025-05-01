class AddRehearsalToTour < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :needs_rehearsal, :boolean, default: false
  end
end
