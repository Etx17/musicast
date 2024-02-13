class AddPreselectionVoteTypeToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :preselection_vote_type, :integer, default: 0
  end
end
