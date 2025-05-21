# To deliver this notification:
#
# PaymentSucceededNotifier.with(record: @post, message: "New post").deliver(User.all)

class PaymentSucceededNotifier < ApplicationNotifier
  deliver_by :database
  param :inscription_order

  notification_methods do

    def message
      "Your payment with ID #{params[:inscription_order]} has succeeded."
    end

    def url
      #TODO
    end
  end

end
