class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  def show
    @posts = @category.posts.near(location_address, 50).paginate(page: params[:page])
    @categories = Category.all

    respond_to do |format|
      format.html
      format.js { render file: 'market/index' }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
