FactoryBot.define do
  # t.bigint "category_id", null: false
  # t.integer "type_item"
  # t.text "description_item"
  # t.string "title"

  factory :requirement_item do
    category factory: :category
    type_item { 0 }
    description_item { Faker::Lorem.paragraph }
    title { Faker::Name.name }

    trait :youtube_link do
      type_item { 0 }
    end

    trait :recommendation_letter do
      type_item { 1 }
    end

    trait :parental_authorization do
      type_item { 2 }
    end

    trait :motivation_essay do
      type_item { 3 }
    end

  end
end
