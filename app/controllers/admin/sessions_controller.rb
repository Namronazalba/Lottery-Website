class Admin::SessionsController < Devise::SessionsController

  # users/sign_in
  def create
    user = User.find_by_email(params[:admin_user][:email])
    if user.nil?
      flash[:notice] = "account does not exists"
      redirect_to action: :new
    elsif user.admin?
      super
    else
      flash[:notice] = "Your account is not admin"
      redirect_to action: :new
    end
  end
end
