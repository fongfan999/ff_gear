class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :location

  protected
  def handle_unverified_request
    true
  end

  private

  def location
    address_ip = if Rails.env.production?
      request.location
    else
      "115.79.53.75"
    end

    session[:location] ||= Geocoder.search(address_ip).first.as_json
  end

  def location_address(address = nil)
    if address.present?
      address
    else
      city = session[:location]['data']['city']
      province = session[:location]['data']['region_name']
      
      "#{city}, #{province}"
    end
  end

  helper_method :location_address
end
