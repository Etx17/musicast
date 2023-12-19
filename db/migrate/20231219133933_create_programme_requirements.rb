class CreateProgrammeRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :programme_requirements do |t|
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
