FactoryBot.define do
  factory :jury do
    user { association(:user, :jury)}
  end
end
