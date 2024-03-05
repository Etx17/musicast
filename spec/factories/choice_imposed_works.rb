FactoryBot.define do
  factory :choice_imposed_work do
    category factory: :category
    title { "Imposed Work" }
    guidelines { "The student must bring 2 arias amongst the list" }
    number_to_select { 2 }
    airs { [FactoryBot.create(:air), FactoryBot.create(:air), FactoryBot.create(:air), FactoryBot.create(:air)] }
  end
end
