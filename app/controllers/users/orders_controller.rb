class Users::OrdersController < ApplicationController
  before_action :authenticate_user!, only: :create
  def cancel
    @order = Order.find params[:order_id]
    if @order.cancel!
      flash[:alert] = "Cancelled successfully!"
    else
      flash[:alert] = "Failed to cancel!"
    end
    redirect_to profile_path
  end

  def create
    @offer = Offer.active.find(params[:offer_id])
    @order = Order.new
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.user = current_user
    @order.genre = :deposit
    @order.offer = @offer
    if @order.save
      flash[:notice] = "Order successfully"
      redirect_to users_shops_path
    else
      render :index
    end
  end
end