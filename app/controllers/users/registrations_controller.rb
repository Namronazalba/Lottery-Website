# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def new
    @promoter = User.find_by_email(cookies[:promoter])&.id
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  def create
    params[:user][:parent_id] = User.find_by_email(cookies[:promoter])&.id
    super
  end

  def update
    if params[:user][:current_password].present?
      if current_user.update_with_password(password_params)
        flash[:notice]="User password updated successfully!"
        sign_in @user, :bypass => true
        redirect_to profile_path
      else
        flash[:error] = 'Oh No! Something Went Wrong in password update field, Please Try Again.'
        render :edit
      end
    else
      if current_user.update(userinfo_params)
        flash[:notice]="User info updated successfully!"
        redirect_to profile_path
      else
        flash[:error] = 'Oh No! Something Went Wrong, Please Try Again.'
        render :edit
      end
    end
  end

  private

  def userinfo_params
    params.require(:user).permit(:email, :parent_id, :username, :phone, :avatar)
  end

  def password_params
    params.require(:user).permit(:email, :username, :phone, :avatar, :password,:password_confirmation, :current_password)
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :parent_id)
  end
end
