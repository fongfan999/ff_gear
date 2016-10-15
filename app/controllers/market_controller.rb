class MarketController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.all

    Rails.logger.debug("get city #{request.location.city}")
  end
end
