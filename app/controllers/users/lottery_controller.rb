class Users::LotteryController < UsersController

  def index
    @categories = Category.all
    @items = Item.all
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end
end