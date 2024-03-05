FactoryBot.define do
  factory :semi_imposed_work do
    category
    title { "Semi Imposed Work" }
    guidelines { "The student must bring arias in french" }
    number { 2 }
    max_length_minutes { 10 }
  end
end
