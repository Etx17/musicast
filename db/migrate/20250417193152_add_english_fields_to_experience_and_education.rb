class AddEnglishFieldsToExperienceAndEducation < ActiveRecord::Migration[8.0]
  def change
    add_column :experiences, :english_title, :string
    add_column :experiences, :english_description, :text
    add_column :educations, :english_title, :string
    add_column :educations, :english_description, :text
  end
end
