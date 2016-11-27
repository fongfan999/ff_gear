class MarketController < ApplicationController
  def index
    @categories = Category.all

    @posts = Post.filtered(current_user)
    if location_coordinates
      @posts = @posts.near(location_coordinates, Post::NO_LIMIT) 
    end

    @posts = @posts.paginate(page: params[:page])
    # Post.order("#{name} #{type}")

    if location_coordinates && current_user.profile.address.present?
      flash.now[:location] = "Vị trí của bạn: #{current_user.profile.address}. #{view_context.link_to('Thay đổi', user_profile_path(current_user.username))}"
    else
      flash.now[:location] = "Cập nhật địa chỉ để hiển thị tin phù hợp. #{view_context.link_to('  Cập nhật', user_profile_path(current_user.username))}"
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
