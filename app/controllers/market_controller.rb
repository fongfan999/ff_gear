class MarketController < ApplicationController
  def index
    @posts = Post.filtered(current_user).near(location, 50)
      .paginate(page: params[:page])
    @categories = Category.all

    if user_signed_in?
      flash.now[:location] = "Vị trí của bạn: #{location}. #{view_context.link_to('Thay đổi', user_profile_path(current_user.username))}"
    end
    
    respond_to do |format|
      format.html
      if params[:page]
        format.js { render file: 'market/load_more' }
      else
        format.js { render file: 'market/load_first' }
      end
    end
  end
end
