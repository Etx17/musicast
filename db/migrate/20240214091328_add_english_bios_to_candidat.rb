class AddEnglishBiosToCandidat < ActiveRecord::Migration[7.0]
  def change
    add_column :candidats, :short_bio_en, :text
    add_column :candidats, :medium_bio_en, :text
    add_column :candidats, :long_bio_en, :text
    remove_column :candidats, :bio, :text
    remove_column :candidats, :cv, :text
  end
end
