class StripeCheckoutSessionService
  def call(event)
    # Get the session from the event object
    session = event.data.object
    # Find the corresponding InscriptionOrder
    inscription_order = InscriptionOrder.find_by(checkout_session_id: session.id)
    # Update the InscriptionOrder status to 'paid'
    if inscription_order
      inscription_order.update(state: 'paid')
      inscription_order.send_notification
    else
      Rails.logger.error "StripeCheckoutSessionService: Couldn't find InscriptionOrder with stripe_session_id = #{session.id}"
    end
  end
end
