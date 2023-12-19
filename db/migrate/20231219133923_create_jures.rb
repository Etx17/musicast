class CreateJures < ActiveRecord::Migration[7.0]
  def change
    create_table :jures do |t|
      t.references :user, null: false, foreign_key: true
      t.text :autres_informations

      t.timestamps
    end
  end
end
