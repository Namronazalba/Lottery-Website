class Admin::UserlistsController < AdminController

  def index
    @users = User.includes(:parent, :bets).where(role: :client)
  end
end