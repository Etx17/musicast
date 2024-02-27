FactoryBot.define do
  factory :competition do
    organism factory: :organism
    nom_concours { Faker::Name.name }
    description { "Concours de chant blablabla" }
  end
end
