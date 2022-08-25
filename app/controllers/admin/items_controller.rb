class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :set_default_batchcount, only: :create

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(items_params)
    if @item.quantity >= 1 && @item.minimum_bet >= 1
      @item.save
      redirect_to admin_items_path
    else
      flash[:alert] = "Quantity or minimum bet must be 1 or above"
      render :new
    end
  end

  def edit; end

  def update
    if params[:item][:quantity].to_i >= 1 && params[:item][:minimum_bet].to_i >= 1
      @item.update(items_params)
      flash[:alert] = "Updated successfully"
      redirect_to admin_items_path
    else
      flash[:alert] = "Quantity or minimum bet must be 1 or above"
      render :edit
    end
  end

  def destroy
    if @item.bets.size == 0
      @item.destroy
      flash[:alert] = "Deleted successfully"
      redirect_to admin_items_path
    else
      flash[:alert] = "Item has bet, unable to delete this record"
      redirect_to admin_items_path
    end

  end

  private

  def items_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bet, :online_at, :offline_at, :start_at, :status, :category_id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_default_batchcount
    params[:item][:batch_count] = params.dig(:item, :zero)
  end
end

