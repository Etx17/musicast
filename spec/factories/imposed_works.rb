FactoryBot.define do
  factory :imposed_work do
    category
    title { "Imposed Work" }
    guidelines { "The student must bring those arias" }
    airs { [FactoryBot.build(:air), FactoryBot.build(:air)] }
  end
end
