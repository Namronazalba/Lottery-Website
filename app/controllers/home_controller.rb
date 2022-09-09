class HomeController < ApplicationController
  before_action :authenticate_user!,except: :index

  def index
    @winners = Winner.published.limit(3)
  end

  def me
    @orders = current_user.orders.includes(:user) if params[:activities] == 'orders' || params[:activities].blank?
    @bets = current_user.bets.includes(:user) if params[:activities] == 'bets'
    @winners = current_user.winners.includes(:user) if params[:activities] == 'winners'
    @children = current_user.children if params[:activities] == 'children'
  end
end
