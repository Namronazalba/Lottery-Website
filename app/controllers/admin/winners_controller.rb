class Admin::WinnersController < AdminController
  before_action :set_winner, except: :index

  def index
    @winners = Winner.includes(:bet, :user, :item)
    @winners = @winners.where(bet: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @winners = @winners.where(user: { email: params[:email] }) if params[:email].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where(created_at: params[:start_date].to_datetime..params[:end_date].to_datetime) if params[:start_date].present? && params[:end_date].present?
  end

  def submit
    if @winner.submit!
      flash[:alert] = "Submitted successfully"
    else
      flash[:alert] = "Failed to submit"
      redirect_to admin_winners_path
    end
  end

  def pay
    if @winner.pay!
      flash[:alert] = "Paid successfully"
    else
      flash[:alert] = "Failed to pay"
      redirect_to admin_winners_path
    end
  end

  def ship
    if @winner.ship!
      flash[:alert] = "Shipped successfully"
    else
      flash[:alert] = "Failed to ship"
      redirect_to admin_winners_path
    end
  end

  def deliver
    if @winner.deliver!
      flash[:alert] = "Delivered successfully"
    else
      flash[:alert] = "Failed to deliver"
      redirect_to admin_winners_path
    end
  end

  def publish
    if @winner.publish!
      flash[:alert] = "Published successfully"
    else
      flash[:alert] = "Failed to publish"
      redirect_to admin_winners_path
    end
  end

  def remove_publish
    if @winner.remove_publish!
      flash[:alert] = "Removed publish successfully"
    end
    flash[:alert] = "Failed to removed publish"
    redirect_to admin_winners_path
  end

  private

  def set_winner
    @winner = Winner.find params[:winner_id]
  end
end
