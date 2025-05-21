FactoryBot.define do
  factory :candidate_rehearsal do
    association :room
    association :tour
    association :candidat

    start_time { Time.zone.tomorrow.at_noon }
    end_time { Time.zone.tomorrow.at_noon + 30.minutes }

    trait :with_pianist do
      association :pianist_accompagnateur
    end

    trait :with_performance do
      association :performance
    end
  end
end
