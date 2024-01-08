Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe_test_pk),
  secret_key: Rails.application.credentials.dig(:stripe_test_sk)
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
