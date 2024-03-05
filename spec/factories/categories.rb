
FactoryBot.define do
  factory :category do
    edition_competition
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    min_age { 10 }
    max_age { 20 }
    price_cents { 1000 }
    price_currency { "EUR" }
    status { 0 }
    allow_own_pianist_accompagnateur { true }
    discipline { "lyrical_singing" }

    trait :hundred_points_vote do
      preselection_vote_type { 1 }
    end

    trait :lyrical_singing do
      discipline {"lyrical_singing"}
    end

    after(:create) do |category|
      (1..3).each do |i|
        category.tours << FactoryBot.create(:tour, tour_number: i, category: category)
      end
    end

  end
end
