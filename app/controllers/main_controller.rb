require 'will_paginate/array'

class MainController < ApplicationController
  def about
    render layout: false
  end

  def search
    if params[:q] =~ /\A@/
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
      respond_to do |format|
        # HTML response
        format.html do
          if params[:filter].present?
            # Filter posts and search posts
            @posts = Post.filter(params[:filter])
              .search(params[:q], params[:filter][:sort])
          else
            # Search as default
            @posts = Post.search(params[:q])
          end

          @paginated_posts = @posts.paginate(page: params[:page], per_page: 12)
        end
        
        # JSON response
        format.json do
          posts_json = Post.search_by('title', params[:q])
                        .limit(5).map do |post| 
            { id: post.id, text: post.title, img: post.first_attachment }
          end

          render json:  posts_json
        end
        
      end
    end
  end
end
