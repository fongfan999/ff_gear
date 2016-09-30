class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
    if session[:attachment_ids].present?
      Attachment.clean_junks(session[:attachment_ids])
      session.delete(:attachment_ids)
    end
  end

  def create
    @product = Product.new(product_params)
    Attachment.clean_junks(params["product"]["rejected_ids"])
    @product.attachments << Attachment.pending(session[:attachment_ids])
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
    if session[:attachment_ids].present?
      Attachment.clean_junks(session[:attachment_ids])
      session.delete(:attachment_ids)
    end
  end

  def update
    if @product.update(product_params)
      @product.attachments << Attachment.pending(session[:attachment_ids])
      Attachment.clean_junks(params["product"]["rejected_ids"])
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
    params.require(:product).permit(:name, :description)
  end
end
