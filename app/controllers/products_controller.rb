class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "Successfully"
      redirect_to @product
    else
      flash[:alert] = "Not Successfully"
      render "new"
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Successfully"
      redirect_to @product
    else
      flash[:alert] = "Not Successfully"
      render "edit"
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "Successfully"
    redirect_to root_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, {attachments: [], 
      attachments_cache: []})
  end
end
