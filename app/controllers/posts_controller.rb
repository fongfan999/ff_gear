class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorite]
  before_action :clean_session, only: [:new, :edit]

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.buyer = current_user

    handle_attachments

    if @post.attachments.empty? || !@post.save
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "new"
    else
      session.delete(:attachment_ids)

      flash[:notice] = "Thành công"
      redirect_to @post
    end
  end

  def edit
  end

  def update
    handle_attachments
    
    if @post.update(post_params)
      if @post.attachments.empty?
        flash.now[:alert] = "Đã xảy ra lỗi"
        render "edit"
      else
        session.delete(:attachment_ids)

        flash[:notice] = "Thành công"
        redirect_to @post
      end
    else
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "edit"
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Successfully"
    redirect_to root_path
  end

  def favorite
    if current_user.favorite?(@post)
      current_user.favorites.destroy(@post)
      @status = false
    else
      current_user.favorites << @post 
      @status = true
    end
    
    respond_to do |format|
      format.html { redirect_to @post }
      format.js { @status }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :address,:description, :category_id,
      :price)
  end

  def clean_session
    if session[:attachment_ids].present?
      Attachment.clean_junks(session[:attachment_ids])
      session.delete(:attachment_ids)
    end
  end

  def handle_attachments
    Attachment.clean_junks(params["post"]["rejected_ids"])
    @post.attachments << Attachment.pending(session[:attachment_ids])
  end
end
