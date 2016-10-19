class MarketController < ApplicationController
  def index
    @posts = Post.near(location_address, 50)
    @categories = Category.all
  end
end
