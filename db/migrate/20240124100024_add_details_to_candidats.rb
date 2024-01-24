class AddDetailsToCandidats < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :last_name, :string
    add_column :candidats, :nationality, :string
    add_column :candidats, :birthdate, :date
    add_column :candidats, :short_bio, :text
    add_column :candidats, :medium_bio, :text
    add_column :candidats, :long_bio, :text
  end
end
