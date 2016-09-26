class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
    Attachment.clean_junks
    session.delete(:attachment_ids)
  end

  def create
    @product = Product.new(product_params)
    @product.attachments << Attachment.pending(
      params["product"]["rejected_ids"]
    )
    if @product.attachments.empty? || !@product.save
      flash[:alert] = "Not Successfully"
      render "new"
    else
      flash[:notice] = "Successfully"
      session.delete(:attachment_ids)
      redirect_to @product
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
