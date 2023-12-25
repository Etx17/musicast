class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.integer :document_type
      t.references :competition, null: false, foreign_key: true
      t.string :file_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
