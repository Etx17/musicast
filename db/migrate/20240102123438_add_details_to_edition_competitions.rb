class AddDetailsToEditionCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :edition_competitions, :end_of_registration, :datetime
    add_column :edition_competitions, :start_date, :date
    add_column :edition_competitions, :end_date, :date
  end
end
