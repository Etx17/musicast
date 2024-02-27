FactoryBot.define do
  factory :organism do
    organisateur factory: :organisateur
    nom { Faker::Name.name }
    description { "Concours de chant blablabla" }
  end
end
