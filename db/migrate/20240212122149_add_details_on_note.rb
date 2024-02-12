class AddDetailsOnNote < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :details, :text
  end
end
