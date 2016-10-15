class WelcomeController < ApplicationController
  def index
    redirect_to market_path and return if current_user
    render layout: false
  end
end
