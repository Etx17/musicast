class AddSpecificDetailsEnglishToEditionCompetitions < ActiveRecord::Migration[8.0]
  def change
    add_column :edition_competitions, :specific_details_english, :text, default: ""
  end
end
