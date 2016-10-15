class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  def show
    @products = @category.products
    @categories = Category.all
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
