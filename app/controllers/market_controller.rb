require 'will_paginate/array'

class MarketController < ApplicationController
  def index
    @categories = Category.all
    
    if sort_relevance?
      @posts = Post.exclude_sold_posts
        .near(location_coordinates, Post::NO_LIMIT).to_a
        .paginate(page: params[:page], per_page: 12)
    else
      @posts = Post.exclude_sold_posts
        .custom_sort(params[:sort])
        .paginate(page: params[:page])
    end

    if location_coordinates
      flash.now[:location] = "Vị trí của bạn: #{current_user.profile.address}. #{view_context.link_to('Thay đổi', user_profile_path(current_user.username))}"
    elsif user_signed_in?
      flash.now[:location] = "Cập nhật địa chỉ để hiển thị tin phù hợp. #{view_context.link_to('Cập nhật', user_profile_path(current_user.username))}"
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
