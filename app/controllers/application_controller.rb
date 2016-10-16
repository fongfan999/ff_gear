class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def location
    if Rails.env.production?
      @location ||= request.location
    else
      @location ||= Geocoder.search("115.79.53.75").first
    end
  end
end
