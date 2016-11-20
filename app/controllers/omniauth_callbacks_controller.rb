class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env['omniauth.auth'])
    
    if user.persisted?
      sign_in user
      
      if request.referrer
        redirect_to request.referrer
      else
        redirect_to user_profile_path(current_user.username)
      end
      
      flash[:notice] = "Đăng nhập thành công"
    else
      redirect_to new_user_session_path
      flash[:alert] = user.errors.full_messages.join(", ")
    end
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
