# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:user][:email])
    if user.nil?
      flash[:notice] = "account does not exists"
      redirect_to action: :new
    elsif user.client?
      super
    end
  end
end