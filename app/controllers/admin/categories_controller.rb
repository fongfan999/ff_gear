class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.search_by("name", params[:q])
                  .paginate(page: params[:page], per_page: 12)
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @category.update(category_params)
      @message = "Cập nhật thành công"
    else
      @message = "Cập nhật thành công"
    end

    respond_to do |format|
      format.js
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
      @message = "Thêm mới thành công"
    else
      @message = "Đã xảy ra lỗi"
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @category.destroy
    @message = "Xoá danh mục thành công"
    
    respond_to do |format|
      format.js
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon, :color)
  end
end
