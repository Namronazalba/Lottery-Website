class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories =Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(categories_params)
    if @category.save
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(categories_params)
      flash[:alert] = "Updated successfully"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.items.size == 0
    @category.destroy
      flash[:alert] = "Deleted successfully"
      redirect_to admin_categories_path
    else
      flash[:alert] = "There is an item there, couldn't delete category!"
      redirect_to admin_categories_path
    end
  end

  private

  def categories_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
