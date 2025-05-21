class AddVoiceTypeToCandidat < ActiveRecord::Migration[8.0]
  def change
    add_column :candidats, :voice_type, :integer, default: 0
  end
end
