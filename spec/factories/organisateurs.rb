FactoryBot.define do
  factory :organisateur do
    user { association(:user, :organiser)}
  end
end
