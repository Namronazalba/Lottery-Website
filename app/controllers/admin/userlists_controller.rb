class Admin::UserlistsController < AdminController
  before_action :authenticate_admin_user!

  def index
    @users = User.includes(:parent)
  end
end