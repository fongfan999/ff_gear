module ProductsHelper
  def location_address(product)
    if product.address.present?
      product.address
    else
      city = session[:location]['data']['city']
      province = session[:location]['data']['region_name']
      
      "#{city}, #{province}"
    end
  end
end
