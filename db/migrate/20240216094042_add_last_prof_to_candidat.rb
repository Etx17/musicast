class AddLastProfToCandidat < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :last_teacher, :string
  end
end
