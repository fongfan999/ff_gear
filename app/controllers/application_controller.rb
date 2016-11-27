class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :location_coordinates, :page_owner?, :policy?
  
  rescue_from ActionController::UrlGenerationError , with: :not_persisted

  protected

  def after_sign_in_path_for(user)
    stored_location_for(user) || user_profile_path(user.username)
  end

  def location_coordinates
    # Using user's address
    if user_signed_in? && current_user.profile.address.present?
      session[:location] ||= Geocoder.search(current_user.profile.address).first.coordinates
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
