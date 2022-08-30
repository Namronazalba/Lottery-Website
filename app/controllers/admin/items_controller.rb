class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy, :start, :pause, :end, :cancel]
  before_action :set_default_batchcount, only: :create


  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(items_params)
    if @item.save
      redirect_to admin_items_path
    else
      flash[:alert] = "Quantity or minimum bet must be 1 or above"
      render :new
    end
  end

  def edit; end

  def update
      if @item.update(items_params)
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

  def start
    @item.start!
    flash[:alert] = "Started successfully!"
    redirect_to admin_items_path
  end

  def pause
    @item.pause!
    flash[:alert] = "Paused successfully"
    redirect_to admin_items_path
  end

  def end
    @item.end!
    flash[:alert] = "Ended successfully!"
    redirect_to admin_items_path
  end

  def cancel
    @item.cancel!
    flash[:alert] = "Cancelled successfully!"
    redirect_to admin_items_path
  end
  private

  def items_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bet, :online_at, :offline_at, :start_at, :status, :category_id)
  end

  def set_item
    @item = Item.find(params[:item_id]||params[:id])
  end

  def set_default_batchcount
    params[:item][:batch_count] = params.dig(:item, :zero)
  end
end

