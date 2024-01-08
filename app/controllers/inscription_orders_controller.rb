class InscriptionOrdersController < ApplicationController
  before_action :authenticate_user!
  def new
  end

  def show
    @inscription_order = InscriptionOrder.where(state: 'pending').find(params[:id])
  end

  def create
    inscription = Inscription.find(params[:inscription_id])
    inscription_order = InscriptionOrder.create!(
      inscription: inscription,
      amount: inscription.category.price,
      state: 'pending',
      user: current_user
    )
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'Inscription',
            },
            unit_amount: inscription_order.amount_cents,
          },
          quantity: 1
        },
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'Commission',
            },
            unit_amount: 250, # 2.50 EUR in cents
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      # To replace candidat_dashboard_candidatures_path,
      success_url: inscription_order_url(inscription_order),
      cancel_url: inscription_orders_url(inscription_order)
    )

    inscription_order.update(checkout_session_id: session.id)
    redirect_to new_inscription_order_payment_path(inscription_order)
  end
end
