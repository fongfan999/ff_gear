class MainController < ApplicationController
  def about
    render layout: false
  end

  def search
    if params[:q] =~ /@/
      # Search users
      @users = User.search(params[:q])

      respond_to do |format|
        format.html { @users = @users.paginate(page: params[:page]) }
        
        format.json do
          users_json = @users.take(5).map do |user| 
            { id: user.id, text: user.name, img: user.avatar.url }
          end

          render json:  users_json
        end
      end
    else
      # Search posts
      @posts = Post.search(params[:q])

      # Filter posts
      @posts = @posts.filter(params[:filter]) if params[:filter].present?

      respond_to do |format|
        format.html { @paginated_posts = @posts.paginate(page: params[:page]) }
        
        format.json do
          posts_json = @posts.limit(5).map do |post| 
            { id: post.id, text: post.title, img: post.first_attachment }
          end

          render json:  posts_json
        end
      end
    end
  end
end
