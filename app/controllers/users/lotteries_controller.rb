class Users::LotteriesController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :set_item, except: :index

  def index
    @categories = Category.all
    @items = Item.active.starting
    @items = @items.filter_by_category(params[:category]) if params[:category].present?

  end

  def show
    if @items = Item.active.starting.find_by_id(params[:id])
      @bet = Bet.new
      @bets = @item.bets.where(user: current_user).where(batch_count: @item.batch_count)
    else
      error_404
    end
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
    @item = Item.find(params[:id] || params[:bet][:item_id])
  end

  def bet_params
    params.require(:bet).permit(:coins, :item_id, :batch_count)
  end
end