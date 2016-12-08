require 'will_paginate/array'

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
      if params[:filter].present?
        # Filter posts and search posts
        @posts = Post.filter(params[:filter]).search(params[:q])
      else
        # Search posts
        @posts = Post.search(params[:q])
      end


      respond_to do |format|
        format.html { @paginated_posts = @posts.paginate(page: params[:page],
          per_page: 4) }
        
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
