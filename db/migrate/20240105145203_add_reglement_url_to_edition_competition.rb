class AddReglementUrlToEditionCompetition < ActiveRecord::Migration[7.0]
  def change
    add_column :edition_competitions, :reglement_url, :string
  end
end
