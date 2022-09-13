class Admin::BannersController < AdminController
  before_action :set_banner, except: [:index, :new, :create]

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banners_params)
    if @banner.save
      flash[:notice] = "Banner added successfully!"
      redirect_to admin_banners_path
    else
      flash[:notice] = "Failed to add banner"
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(banners_params)
      flash[:notice] = "Banner updated successfully!"
      redirect_to admin_banners_path
    else
      flash[:alert] = "Failed to update banner"
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      flash[:alert] = "Banner deleted successfully!"
      redirect_to admin_banners_path
    else
      flash[:alert] = "Failed to delete banner"
      redirect_to admin_banners_path
    end
  end

  private

  def banners_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end

end