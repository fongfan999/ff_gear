class MarketController < ApplicationController
  def index
    @posts = Post.all
    @categories = Category.all
  end
end
