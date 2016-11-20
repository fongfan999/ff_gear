class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorite,
    :mark_as_sold, :report]
  before_action :clean_session, only: [:new, :edit]

  def show
    if params[:notification_id]
      Notification.find(params[:notification_id]).mark_as_read
    end

    # Search by name this post
    @related_posts = @post.related_posts
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.owner = current_user

    handle_attachments

    if @post.attachments.empty? || !@post.save
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "new"
    else
      session.delete(:attachment_ids)

      flash[:notice] = "Đăng tin thành công"
      redirect_to @post
    end
  end

  def edit
  end

  def update
    handle_attachments

    if @post.attachments.empty? || !@post.update(post_params)
      flash.now[:alert] = "Đã xảy ra lỗi"
      render "edit"
    else
      session.delete(:attachment_ids)

      flash[:notice] = "Cập nhật thành công"
      redirect_to @post
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Successfully"
    redirect_to root_path
  end

  def favorite
    @status = if current_user.favorite?(@post)
      current_user.favorites.destroy(@post)
      false
    else
      current_user.favorites << @post 
      true
    end
    
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def mark_as_sold
    @post.toggle!(:sold)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def report
    # debugger
    report_id = params[:post][:report_id]
    report = Report.find(report_id)

    @post.owner.get_notification(@post, current_user, report.name, nil)

    # Send to admin
    # admin.get_notification(@post, current_user, message, nil) if report.public?

    respond_to do |format|
      format.html { redirect_to @post, notice: "Thank you so much" }
      format.js
    end
  end

  # user's posts
  def index
    @user = User.find_by_username(params[:username])

    @posts = @user.posts.near(location, 50).paginate(page: params[:page])
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :address,:description, :tag_names,
      :category_id, :price)
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
