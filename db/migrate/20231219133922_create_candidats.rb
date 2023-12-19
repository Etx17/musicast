class CreateCandidats < ActiveRecord::Migration[7.0]
  def change
    create_table :candidats do |t|
      t.references :user, null: false, foreign_key: true
      t.text :cv
      t.text :bio

      t.timestamps
    end
  end
end
