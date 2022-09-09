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
      flash[:notice] = "Submitted successfully"
    else
      flash[:alert] = "Failed to submit"
    end
    redirect_to admin_winners_path
  end

  def pay
    if @winner.pay!
      flash[:notice] = "Paid successfully"
    else
      flash[:alert] = "Failed to pay"
    end
    redirect_to admin_winners_path
  end

  def ship
    if @winner.ship!
      flash[:notice] = "Shipped successfully"
    else
      flash[:alert] = "Failed to ship"
    end
    redirect_to admin_winners_path
  end

  def deliver
    if @winner.deliver!
      flash[:notice] = "Delivered successfully"
    else
      flash[:alert] = "Failed to deliver"
    end
    redirect_to admin_winners_path
  end

  def publish
    if @winner.publish!
      flash[:notice] = "Published successfully"
    else
      flash[:alert] = "Failed to publish"
    end
    redirect_to admin_winners_path
  end

  def remove_publish
    if @winner.remove_publish!
      flash[:alert] = "Removed publish successfully"
    else
      flash[:alert] = "Failed to removed publish"
    end
    redirect_to admin_winners_path
  end

  private

  def set_winner
    @winner = Winner.find params[:winner_id]
  end
end
