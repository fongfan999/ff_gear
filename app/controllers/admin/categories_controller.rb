class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all.paginate(page: params[:page], per_page: 10)
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Cập nhật thành công"
      redirect_to admin_categories_path
    else
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "edit"
    end
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Thêm mới thành công"
      redirect_to admin_categories_path
    else
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "new"
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Xoá danh mục thành công"
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon)
  end
end
