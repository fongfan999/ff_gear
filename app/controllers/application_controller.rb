class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :location, :page_owner?, :policy?
  
  rescue_from ActionController::UrlGenerationError , with: :not_persisted

  protected

  def after_sign_in_path_for(user)
    stored_location_for(user) || user_profile_path(user.username)
  end

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

      if session[:location].present?
        city = session[:location]['data']['city']
        province = session[:location]['data']['region_name']
        
        "#{city}, #{province}"
      else
        "Vietnam"
      end
      
    end
  end

  def page_owner?(user)
    return false unless user_signed_in?
    
    current_user.id == user.id
  end

  def policy?(user)
    page_owner?(user) || current_user.admin?
  end

  def authorize(user)
    authenticate_user!
    
    unless policy?(user)
      flash[:alert] = "Bạn không có quyền truy cập chức năng này"
      redirect_to market_path
    end
  end

  private

  def not_persisted
    flash[:alert] = "Người dùng không tồn tại"
    redirect_to market_path
  end
end
