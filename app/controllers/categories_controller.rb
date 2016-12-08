class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  
  def show
    @posts = @category.posts

    if sort_relevance?
      @posts = @posts.exclude_sold_posts
        .near(location_coordinates, Post::NO_LIMIT)
        .paginate(page: params[:page])
    else
      @posts = @posts.exclude_sold_posts
        .custom_sort(params[:sort])
        .paginate(page: params[:page])
    end

    respond_to do |format|
      if params[:page]
        format.js { render file: 'market/load_more' }
      else
        format.js { render file: 'market/load_first' }
      end
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
