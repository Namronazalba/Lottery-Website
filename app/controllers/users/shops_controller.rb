class Users::ShopsController < ApplicationController
  before_action :set_offer, only: :orders
  before_action :authenticate_user!, only: :orders

  def index
    @offers = Offer.active
  end

  def orders
    @order = Order.new()
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.user = current_user
    @order.offer = @offer
    if @order.save
      flash[:notice] = "Order successfully"
      redirect_to users_shops_path
    else
      render :new
    end
  end

  def set_offer
    @offer = Offer.active.find(params[:shop_id])
  end
end
