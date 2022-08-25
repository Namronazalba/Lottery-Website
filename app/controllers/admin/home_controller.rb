class Admin::HomeController < AdminController

  def index
    @bets = Bet.includes(:item, :user)
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(item: {name: params[:name]}) if params[:name].present?
    @bets = @bets.where(user: {email: params[:email]}) if params[:email].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
    @bets = @bets.where(created_at: params[:start_date].to_datetime..params[:end_date].to_datetime) if params[:start_date].present? && params[:end_date].present?
  end
end