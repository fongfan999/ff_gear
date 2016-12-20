class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env['omniauth.auth'])
    
    if user.persisted?
      sign_in_and_redirect user
      Visit.delay(run_at: 1.minute.from_now).track_sign_in(user)
      
      flash[:notice] = "Đăng nhập thành công"
    else
      redirect_to new_user_session_path
      flash[:alert] = user.errors.full_messages.join(", ")
    end
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
