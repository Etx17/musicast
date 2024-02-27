FactoryBot.define do
  factory :candidat do
    user { association(:user, :candidat)}
  end
end
