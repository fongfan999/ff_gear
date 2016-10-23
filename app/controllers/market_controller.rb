class MarketController < ApplicationController
  def index
    @posts = Post.near(location_address, 50).paginate(page: params[:page])
    @categories = Category.all

    respond_to do |format|
      format.html
      if params[:page]
        format.js 
      else
        format.js { render file: 'categories/show' }
      end
    end
  end
end
