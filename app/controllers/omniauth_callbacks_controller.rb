class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.persisted?
      sign_in user
      
      if request.referrer
        redirect_to request.referrer
      else
        redirect_to profile_path(current_user.username)
      end
      
      flash[:notice] = "Signed in!"
    else
      redirect_to root_path
      flash[:alert] = "Failed :("
    end
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
