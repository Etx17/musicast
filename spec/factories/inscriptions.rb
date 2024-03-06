FactoryBot.define do
  factory :inscription do
    terms_accepted { true }
    category
    candidat
    price_cents { 1000 }
    candidate_brings_pianist_accompagnateur { false }
    is_late_inscription { false }
    time_preference { "no_preference" }

    trait :draft do
      status { "draft" }
    end

    trait :in_review do
      status { "in_review" }
    end

    trait :accepted do
      status { "accepted" }
    end
  end
end
