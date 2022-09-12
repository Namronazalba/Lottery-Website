class Admin::InvitesController < AdminController

  def index
    @users = User.includes(:children, :parent, :bets).where.not(parent: nil).where(role: :client)
    @users = @users.where(parent: { email: params[:parent_email] }) if params[:parent_email].present?
  end
end