FactoryBot.define do

  factory :air do
    title { Faker::Music::Opera.mozart }
    length_minutes { 3 }
    composer { "Verdi" }
    oeuvre { "Oeuvres completes III" }
    character { "Violetta" }
    tonality { "F" }
    infos { "This is a very nice aria" }

  end
end
