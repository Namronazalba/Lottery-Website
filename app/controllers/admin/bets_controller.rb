class Admin::BetsController < AdminController
  before_action :set_bet, only: :cancel

  def index
    @bets = Bet.includes(:item, :user)
  end

  def cancel
    @bet.cancel!
    flash[:alert] = "Cancelled successfully!"
    redirect_to admin_bets_path
  end

  private

  def set_bet
    @bet = Bet.find(params[:bet_id] || params[:id])
  end
end