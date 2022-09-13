class Admin::NewstickersController < ApplicationController
  before_action :set_newsticker, except: [:index, :new, :create]

  def index
    @newstickers = Newsticker.includes(:admin)
  end

  def new
    @newsticker = Newsticker.new
  end

  def create
    @newsticker = Newsticker.new(newstickers_params)
    @newsticker.admin = current_admin_user
    if @newsticker.save
      flash[:notice] = "Newsticker added successfully!"
      redirect_to admin_newstickers_path
    else
      flash[:notice] = "Failed to add newsticker"
      render :new
    end
  end

  def edit; end

  def update
    if @newsticker.update(newstickers_params)
      flash[:notice] = "Newsticker updated successfully!"
      redirect_to admin_newstickers_path
    else
      flash[:alert] = "Newsticker failed update"
      render :edit
    end
  end

  def destroy
    if @newsticker.destroy
      flash[:alert] = "Newsticker deleted successfully!"
      redirect_to admin_newstickers_path
    else
      flash[:alert] = "Failed to delete newsticker"
      redirect_to admin_newstickers_path
    end
  end

  private

  def newstickers_params
    params.require(:newsticker).permit(:content, :status)
  end

  def set_newsticker
    @newsticker = Newsticker.find(params[:id])
  end
end
