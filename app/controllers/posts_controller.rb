class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorite,
    :mark_as_sold, :report]
  before_action :clean_attachments_session, only: [:new, :edit]
  before_action :notification_on_params, only: [:show]

  def show
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

    if failed_attachments_validation? || !@post.save
      flash.now[:alert] = "Đã xảy ra lỗi. Vui lòng thử lại"
      render "new"
    else
      session.delete(:attachment_ids)

      flash[:notice] = "Đăng tin thành công"
      redirect_to @post
    end
  end

  def edit
    authorize @post.owner
  end

  def update
    authorize @post.owner
    handle_attachments

    if failed_attachments_validation? || !@post.update(post_params)
      flash.now[:alert] = "Đã xảy ra lỗi. Vui lòng thử lại"
      render "edit"
    else
      session.delete(:attachment_ids)

      flash[:notice] = "Cập nhật thành công"
      redirect_to @post
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Xoá tin thành công"
    redirect_to root_path
  end

  def favorite
    if current_user.favorite?(@post)
      current_user.favorites.destroy(@post)
    else
      current_user.favorites << @post 
    end
    
    head :ok
  end

  def mark_as_sold
    @post.toggle!(:sold)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def report
    return unless params[:post][:report_id]

    report_id = params[:post][:report_id]
    report = Report.find(report_id)

    @post.owner.get_notification(@post, current_user, report.name, nil)

    # Send to admin
    if report.public?
      User.find_each do |user|
        if user.admin?
          user.get_notification(@post, current_user, report.name, nil)
        end
      end
    end

    head :ok
  end

  # user's posts
  def index
    @user = User.find_by_username(params[:username])

    @posts = @user.posts
    if location_coordinates
      @posts = @posts.near(location_coordinates, Post::NO_LIMIT)
    end
    @posts = @posts.paginate(page: params[:page])
  end

  private

  def set_post
    @post = Post.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Tin hiện không tồn tại"
    redirect_to root_path
  end

  def post_params
    params.require(:post).permit(:title, :address,:description, :tag_names,
      :category_id, :price)
  end

  def failed_attachments_validation?
    @post.attachments.empty? || @post.attachments.count > 5
  end

  def clean_attachments_session
    session.delete(:attachment_ids) if session[:attachment_ids].present?
  end

  def handle_attachments
    Attachment.unlink_post(params["post"]["rejected_ids"])
    @post.attachments << Attachment.pending(session[:attachment_ids])
  end
end
