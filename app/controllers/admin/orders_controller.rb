class Admin::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.all
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
