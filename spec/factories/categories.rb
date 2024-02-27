# create_table "categories", force: :cascade do |t|
#   t.bigint "edition_competition_id", null: false
#   t.string "name"
#   t.text "description"
#   t.integer "min_age"
#   t.integer "max_age"
#   t.integer "discipline"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.string "slug"
#   t.integer "price_cents", default: 0, null: false
#   t.string "price_currency", default: "EUR", null: false
#   t.integer "status", default: 0
#   t.boolean "allow_own_pianist_accompagnateur"
#   t.integer "preselection_vote_type", default: 0
#   t.index ["edition_competition_id"], name: "index_categories_on_edition_competition_id"
#   t.index ["slug"], name: "index_categories_on_slug", unique: true
# end
FactoryBot.define do
  factory :category do
    edition_competition factory: :edition_competition
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    min_age { 10 }
    max_age { 20 }
    price_cents { 1000 }
    price_currency { "EUR" }
    status { 0 }
    allow_own_pianist_accompagnateur { true }
    discipline { 0 }

    trait :hundred_points_vote do
      preselection_vote_type { 1 }
    end

    trait :lyrical_singing do
      discipline {"lyrical_singing"}
    end

  end
end
