class CreateInscriptionItemRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :inscription_item_requirements do |t|
      t.references :inscription, null: false, foreign_key: true
      t.references :requirement_item, null: false, foreign_key: true
      t.text :submitted_content

      t.timestamps
    end
  end
end
