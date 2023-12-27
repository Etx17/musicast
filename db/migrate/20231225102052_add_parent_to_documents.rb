class AddParentToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_reference :documents, :parent, polymorphic: true, null: false
    remove_column :documents, :competition_id, :bigint
  end
end
