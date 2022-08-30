class Admin::WinnersController < AdminController
  before_action :winner_params, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.includes(:bet, :user, :item)
    @winners = @winners.where(bet: {serial_number: params[:serial_number]}) if params[:serial_number].present?
    @winners = @winners.where(user: {email: params[:email]}) if params[:email].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where(created_at: params[:start_date].to_datetime..params[:end_date].to_datetime) if params[:start_date].present? && params[:end_date].present?
  end

  def submit
    @winner.submit!
    flash[:alert] = "Submitted successfully"
    redirect_to admin_winners_path
  end

  def pay
    @winner.pay!
    flash[:alert] = "Paid successfully"
    redirect_to admin_winners_path
  end

  def ship
    @winner.ship!
    flash[:alert] = "Shipped successfully"
    redirect_to admin_winners_path
  end

  def deliver
    @winner.deliver!
    flash[:alert] = "Delivered successfully"
    redirect_to admin_winners_path
  end

  def publish
    @winner.publish!
    flash[:alert] = "Published successfully"
    redirect_to admin_winners_path

  end

  def remove_publish
    @winner.remove_publish!
    flash[:alert] = "Removed publish successfully"
    redirect_to admin_winners_path
  end

  private

  def winner_params
    @winner = Winner.find params[:winner_id]
  end
end
