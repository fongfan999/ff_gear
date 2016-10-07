class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update,
    :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :clean_session, only: [:new, :edit]

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

    handle_attachments

    if @product.attachments.empty? || !@product.save
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "new"
    else
      session.delete(:attachment_ids)

      flash[:notice] = "Thành công"
      redirect_to @product
    end
  end

  def edit
  end

  def update
    handle_attachments

    if @product.update(product_params)
      if @product.attachments.empty?
        flash.now[:alert] = "Đã xảy ra lỗi"
        render "edit"
      else
        session.delete(:attachment_ids)

        flash[:notice] = "Thành công"
        redirect_to @product
      end
    else
      flash.now[:alert] = "Đã xảy ra lỗi"
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

  def clean_session
    if session[:attachment_ids].present?
      Attachment.clean_junks(session[:attachment_ids])
      session.delete(:attachment_ids)
    end
  end

  def handle_attachments
    Attachment.clean_junks(params["product"]["rejected_ids"])
    @product.attachments << Attachment.pending(session[:attachment_ids])
  end
end
