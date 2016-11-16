class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  protected

  def location
    # Using user's address
    if user_signed_in? && current_user.profile && current_user.profile.address.present?
      current_user.profile.address
    else
      # Using address from user's IP
      address_ip = if Rails.env.production?
        request.location
      else
        "115.79.53.75"
      end

      session[:location] ||= Geocoder.search(address_ip).first.as_json

      city = session[:location]['data']['city']
      province = session[:location]['data']['region_name']
      
      "#{city}, #{province}"
    end
  end

  helper_method :location
end
