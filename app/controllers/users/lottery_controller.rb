class Users::LotteryController < UsersController

  def index
    @categories = Category.all
    @items = Item.active
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end
end