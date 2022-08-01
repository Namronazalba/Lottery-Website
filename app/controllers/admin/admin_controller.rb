class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @posts = Post.includes(:user).inspecting
  end

  private

  def check_admin
    unless current_user.admin?
      flash[:notice] = "You do not have permission"
      redirect_to admins_path
    end
  end
end
