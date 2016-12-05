class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  
  def show
    @posts = @category.posts.exclude_current_user(current_user)

    if sort_relevance?
      @posts = @posts.near(location_coordinates, Post::NO_LIMIT) 
    else
      @posts = @posts.custom_sort(params[:sort])
    end
    
    @posts = @posts.paginate(page: params[:page])

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
