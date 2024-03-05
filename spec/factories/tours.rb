
FactoryBot.define do
  factory :tour do
    association :category, factory: :category, strategy: :build

    title { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    start_date { Faker::Date.forward(days: 23) }
    final_performance_submission_deadline { start_date - 1.day }
    max_end_of_day_time { Faker::Time.forward(days: 23, period: :evening) }
    new_day_start_time { max_end_of_day_time - 1.hour }
    tour_number { 1 }

    trait :creating_schedule do
      creating_schedule { true }
    end
  end
end
