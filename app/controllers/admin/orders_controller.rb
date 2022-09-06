class Admin::OrdersController < AdminController

  def index
    @orders = Order.all
  end

  private

  def oders_params
    params.require(:order).permit(:user_id, :offer_id, :serial_number, :state, :amount, :coin, :remarks, :genre )
  end
end
