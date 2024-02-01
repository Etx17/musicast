class AddStatusToEditionCompetition < ActiveRecord::Migration[7.0]
  def change
    add_column :edition_competitions, :status, :integer, default: 0
  end
end
