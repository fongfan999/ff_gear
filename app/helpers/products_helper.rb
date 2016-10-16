module ProductsHelper
  def location_address(product)
    if product.address.present?
      product.address
    else
      "#{@location.city}, #{@location.province}"
    end
  end
end
