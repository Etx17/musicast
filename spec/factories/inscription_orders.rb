
FactoryBot.define do
  factory :inscription_order do
    inscription
    state { "pending" }
    checkout_session_id { "cs_test_0000000000000000000000000000000000000000000000000000000000" }
    user { inscription.candidat.user }
    amount_cents { inscription.category.price_cents }
    amount_currency { "EUR" }
  end
end
