module PostsHelper
  def location_address(post)
    if post.address.present?
      post.address
    else
      city = session[:location]['data']['city']
      province = session[:location]['data']['region_name']
      
      "#{city}, #{province}"
    end
  end
end
