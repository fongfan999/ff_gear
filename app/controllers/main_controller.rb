class MainController < ApplicationController
  def about
    render layout: false
  end

  def search
    if params[:q].present?
      @posts = Post.search(params[:q])
    else
      @posts = Post.all
    end

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
