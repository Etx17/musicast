
FactoryBot.define do
  factory :edition_competition do
    competition factory: :competition

    annee { 2025 }
    details_specifiques { "Details specifiques blablablabla" }
    end_of_registration { "2025-01-01 00:00:00" }
    start_date { "2025-01-10" }
    end_date { "2020-01-12" }
    reglement_url { "https://www.google.com" }

    status { "draft" }

    trait :published do
      status { "published" }
    end
  end
end
