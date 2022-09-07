class Users::OrdersController < ApplicationController
  before_action :set_order, only: :cancel

  def cancel
    if @order.cancel!
      flash[:alert] = "Cancelled successfully!"
    else
      flash[:alert] = "Failed to cancel!"
    end
    redirect_to profile_path
  end

  private

  def set_order
    @order = Order.find params[:order_id]
  end
end