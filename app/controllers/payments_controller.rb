class PaymentsController < ApplicationController

  def new
    @inscription_order = current_user.inscription_orders.where(state: 'pending').find(params[:inscription_order_id])
  end
end
