class Users::SharesController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_winner, except: :index

  def index
    @winners = Winner.published
  end

  def show; end

  def update
    if @winner.share!
      if @winner.update(shares_params)
        flash[:notice] = "Updated Successfully!"
        redirect_to profile_path
      else
        render :edit
      end
    else
      render :edit
    end
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).find(params[:id])
  end

  def shares_params
    params.require(:winner).permit(:picture, :comment)
  end
end