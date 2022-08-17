class Admin::UserlistsController < AdminController

  def index
    @users = User.includes(:parent)
  end
end