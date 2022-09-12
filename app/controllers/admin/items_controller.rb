class Admin::ItemsController < AdminController
  before_action :set_item, except: [:index, :new, :create]
  before_action :set_default_batch_count, only: :create

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(items_params)
    if @item.save
      flash[:notice] = "Item added successfully!"
      redirect_to admin_items_path
    else
      flash[:notice] = "Quantity or minimum bet must be 1 or above"
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(items_params)
      flash[:notice] = "Item updated successfully!"
      redirect_to admin_items_path
    else
      flash[:notice] = "Quantity or minimum bet must be 1 or above"
      render :edit
    end
  end

  def destroy
    if @item.destroy
      flash[:alert] = "Item deleted successfully!"
      redirect_to admin_items_path
    else
      flash[:alert] = "Item has bet, unable to delete this record"
      redirect_to admin_items_path
    end
  end

  def start
    if @item.start!
      flash[:notice] = "Started successfully!"
    else
      flash[:alert] = "Failed to start!"
    end
    redirect_to admin_items_path
  end

  def pause
    if @item.pause!
      flash[:notice] = "Paused successfully"
    else
      flash[:alert] = "Failed to pause"
    end
    redirect_to admin_items_path
  end

  def end
    if @item.end!
      flash[:notice] = "Ended successfully!"
    else
      flash[:alert] = "Failed to end!"
    end
    redirect_to admin_items_path
  end

  def cancel
    if @item.cancel!
      flash[:alert] = "Item cancelled!"
    else
      flash[:alert] = "Failed to cancel!"
    end
    redirect_to admin_items_path
  end

  private

  def items_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bet, :online_at, :offline_at, :start_at, :status, :category_id)
  end

  def set_item
    @item = Item.find(params[:item_id] || params[:id])
  end

  def set_default_batch_count
    params[:item][:batch_count] = params.dig(:item, :zero)
  end
end

