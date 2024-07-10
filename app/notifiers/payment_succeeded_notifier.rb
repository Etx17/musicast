# To deliver this notification:
#
# PaymentSucceededNotifier.with(record: @post, message: "New post").deliver(User.all)

class PaymentSucceededNotifier < ApplicationNotifier
  deliver_by :database
  param :inscription_order

  def message
    "Your payment with ID #{params[:inscription_order]} has succeeded."
  end

  def url
    user_post_path(recipient, params[:payment_id])
  end

end
