class AddRepertoireToCandidat < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :repertoire, :text
  end
end
