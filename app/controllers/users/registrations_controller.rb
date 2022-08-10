# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    @user = current_user
  end

  def update
    if params[:user][:current_password].present?
      if current_user.update_with_password(password_params)
        flash[:alert]="Updated successfully!"
        sign_in @user, :bypass => true
        redirect_to edit_user_registration_path
      else
        flash[:error] = 'Oh No! Something Went Wrong in password update field, Please Try Again.'
        render :edit
      end
    else
      if current_user.update(userinfo_params)
        flash[:alert]="Updated successfully!"
        redirect_to edit_user_registration_path
      else
        flash[:error] = 'Oh No! Something Went Wrong, Please Try Again.'
        render :edit
      end
    end
  end

  private

  def userinfo_params
    params.require(:user).permit(:email, :username, :phone, :avatar)
  end

  def password_params
    params.require(:user).permit(:email, :username, :phone, :avatar, :password,:password_confirmation, :current_password)
  end
end
