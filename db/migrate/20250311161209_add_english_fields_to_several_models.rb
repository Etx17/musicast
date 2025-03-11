class AddEnglishFieldsToSeveralModels < ActiveRecord::Migration[8.0]
  def change
    # Choice imposed works
    add_column :choice_imposed_works, :title_english, :string
    add_column :choice_imposed_works, :guidelines_english, :text

    # Semi imposed works
    add_column :semi_imposed_works, :title_english, :string
    add_column :semi_imposed_works, :guidelines_english, :text

    # Imposed works
    add_column :imposed_works, :title_english, :string
    add_column :imposed_works, :guidelines_english, :text

    # Airs
    add_column :airs, :infos_english, :text

    # Tours
    add_column :tours, :title_english, :string
    add_column :tours, :description_english, :text

    # Tour requirements
    add_column :tour_requirements, :description_english, :text

    # Requirement items
    add_column :requirement_items, :description_item_english, :string

    # Prizes : titles, description, other_reward_english
    add_column :prizes, :title_english, :string
    add_column :prizes, :description_english, :text
    add_column :prizes, :other_reward_english, :string
  end
end
