# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:user][:email])
    if user.nil?
      flash[:notice] = "account does not exists"
      redirect_to action: :new
    elsif user.client?
      super
    else
      flash[:notice] = "Your are not a client"
      redirect_to action: :new
    end
  end
end