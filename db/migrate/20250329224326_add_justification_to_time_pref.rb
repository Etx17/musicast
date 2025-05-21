class AddJustificationToTimePref < ActiveRecord::Migration[8.0]
  def change
    add_column :inscriptions, :time_justification, :text
  end
end
