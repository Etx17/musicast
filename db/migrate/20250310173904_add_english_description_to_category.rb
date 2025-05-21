class AddEnglishDescriptionToCategory < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :description_english, :text
  end
end
