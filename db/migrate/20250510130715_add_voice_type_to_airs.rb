class AddVoiceTypeToAirs < ActiveRecord::Migration[8.0]
  def change
    add_column :airs, :fach, :integer, default: 0
  end
end
