# spec/requests/stripe_callbacks_spec.rb

require 'rails_helper'

RSpec.describe "Stripe callbacks", type: :request do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }
  
  it "updates order and inscription status when payment succeeds" do
    order = FactoryBot.create(:inscription_order, checkout_session_id: 'cs_test_0000000000000000000000000000000000000000000000000000000000')
    inscription = order.inscription

    event = StripeMock.mock_webhook_event('checkout.session.completed', {data:{ object:{id: 'cs_test'}}})

    # Here i mock the object that is created when my stripe callback event is triggered. (in stripe.rb)
    StripeCheckoutSessionService.new.call(event)

    order.reload
    inscription.reload

    expect(order.state).to eq('paid')
    expect(inscription.status).to eq('in_review')
  end
end
