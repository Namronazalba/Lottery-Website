class Admin::BonusController < AdminController
  before_action :set_user

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.genre = :bonus
    @order.user = @user
    if @order.save
      if @order.may_pay? && @order.pay!
        flash[:notice]= 'Bonus added successfully!'
      else
        flash[:alert]= 'transaction failed'
        @order.cancel!
      end
      redirect_to new_admin_userlist_bonu_path
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end

  def set_user
    @user = User.find params[:userlist_id]
  end
end