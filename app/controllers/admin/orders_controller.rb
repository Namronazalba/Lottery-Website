class Admin::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.includes(:user, :offer)

    @total_coins = @orders.map(&:coin).sum
    @total_amount = @orders.map(&:amount).sum

    @orders = @orders.where(user: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(offer: { name: params[:offer] }) if params[:offer].present?
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(created_at: params[:start_date].to_datetime..params[:end_date].to_datetime) if params[:start_date].present? && params[:end_date].present?

    @subtotal_coins = @orders.map(&:coin).sum
    @subtotal_amount = @orders.map(&:amount).sum
  end
  def submit
    if @order.submit!
      flash[:alert] = "Submit successfully!"
    else
      flash[:alert] = "Failed to start!"
    end
    redirect_to admin_orders_path
  end

  def cancel
    if @order.cancel!
      flash[:alert] = "Cancelled successfully!"
    else
      flash[:alert] = "Failed to cancel!"
    end
    redirect_to admin_orders_path
  end

  def pay
    if @order.pay!
      flash[:alert] = "Payed successfully!"
    else
      flash[:alert] = "Failed to pay!"
    end
    redirect_to admin_orders_path
  end

  private

  def oders_params
    params.require(:order).permit(:user_id, :offer_id, :serial_number, :state, :amount, :coin, :remarks, :genre )
  end

  def set_order
    @order = Order.find params[:order_id]
  end
end
