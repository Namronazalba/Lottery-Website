class AddressController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @addresses = current_user.addresses.includes(:user)
  end
  def show; end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      flash[:notice] = "New address added successfully!"
      redirect_to address_index_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      flash[:notice] = "Updated successfully"
      redirect_to address_index_path
    else
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:alert] = "Deleted successfully"
      redirect_to address_index_path
    end
  end

  private

  def address_params
    params.require(:address).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :region_id, :province_id, :city_id, :barangay_id)
  end

  def set_address
    @address = Address.find(params[:id])
  end
end
