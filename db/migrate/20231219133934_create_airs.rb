class CreateAirs < ActiveRecord::Migration[7.0]
  def change
    create_table :airs do |t|
      t.string :title
      t.integer :length_minutes
      t.string :composer
      t.string :oeuvre
      t.string :character
      t.string :tonality

      t.timestamps
    end
  end
end
