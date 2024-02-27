FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    accepted_terms { true }


    trait :candidat do
      inscription_role { "candidate" }
    end

    trait :organiser do
      inscription_role { "organiser" }
    end

    trait :jury do
      inscription_role { "jury" }
    end

    trait :partner do
      inscription_role { "partner" }
    end
  end
end
