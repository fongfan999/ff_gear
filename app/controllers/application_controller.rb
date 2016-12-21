class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :location_coordinates, :page_owner?, :policy?
  
  rescue_from ActionController::UrlGenerationError , with: :not_persisted
  rescue_from Geocoder::NetworkError , with: :refresh_page

  protected

  def after_sign_in_path_for(user)
    stored_location_for(user) || user_profile_path(user.username)
  end

  def location_coordinates
    return session[:location_coordinates] if session[:location_coordinates]
    
    # Using user's address
    if user_signed_in? && current_user.profile.address.present?
      result = Geocoder.search(current_user.profile.address).first
      
      session[:location_coordinates] = if result.present?
        result.coordinates
      else
        nil
      end
    end
  end

  def page_owner?(user)
    return false unless user_signed_in?
    
    current_user.id == user.id
  end

  def policy?(user)
    user_signed_in? && (page_owner?(user) || current_user.admin?)
  end

  def authorize(user)
    unless policy?(user)
      flash[:alert] = "Bạn không có quyền thực hiện hành động này"
      redirect_to root_path
    end
  end

  def sort_relevance?
    location_coordinates and 
      (params[:sort] == "relevance" || params[:sort].nil?)
  end

  def notification_on_params
    if !params[:notification_id] || !user_signed_in?
      return false
    end
    
    if notice = current_user.notifications.find_by_id(params[:notification_id])
      notice.mark_as_read
    end
  end

  private

  def not_persisted
    flash[:alert] = "Người dùng không tồn tại"
    redirect_to root_path
  end

  def refresh_page
    redirect_to root_path
  end
end
