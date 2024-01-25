class CreatePianisteAccompagnateurs < ActiveRecord::Migration[7.0]
  def change
    create_table :pianist_accompagnateurs do |t|
      t.string :email
      t.string :phone_number
      t.string :full_name

      t.timestamps
    end
  end
end
