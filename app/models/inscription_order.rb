class InscriptionOrder < ApplicationRecord
  belongs_to :user
  belongs_to :inscription, optional: true

  enum state: { pending: 0, paid: 1, failed: 2 }
  monetize :amount_cents

  after_update :set_inscription_status, if: :saved_change_to_state?

  def send_notification
    PaymentSucceededNotifier.with(inscription_order: self, message: "Payment succedeed").deliver(User.all)
  end

  private

  def set_inscription_status
    return unless paid?

    inscription.in_review!

  end
end
