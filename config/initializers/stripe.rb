require 'stripe_checkout_session_service'

Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.dig(:stripe_test_pk),
  secret_key: Rails.application.credentials.dig(:stripe_test_sk),
  signing_secret:  Rails.application.credentials.dig(:stripe_test_wh)
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
end
