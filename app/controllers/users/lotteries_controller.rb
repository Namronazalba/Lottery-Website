class Users::LotteriesController < UsersController
  before_action :set_bet_item, only: :create
  before_action :set_item, only: :show

  def index
    @categories = Category.all
    @items = Item.active
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
  end

  def show
    @bet = Bet.new
  end

  def create
    begin
      loop = params[:bet][:coins].to_i
      params[:bet][:coins] = 1
      ActiveRecord::Base.transaction do
        loop.times do
          @bet = Bet.new(bet_params)
          @bet.item = @item
          @bet.user = current_user
          @bet.batch_count = @item.batch_count
          @bet.save!
        end
      end
      flash[:notice] = "successfully created"
    rescue ActiveRecord::RecordInvalid => exception
      flash[:alert] = exception
    end
    redirect_to users_lotteries_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_bet_item
    @item = Item.find(params[:bet][:item_id])
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id, :batch_count)
  end

end