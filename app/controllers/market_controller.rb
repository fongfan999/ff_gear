class MarketController < ApplicationController
  def index
    @products = Product.all
  end
end
