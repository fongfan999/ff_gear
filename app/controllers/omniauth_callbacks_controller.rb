class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.persisted?
      sign_in user
      redirect_to root_path
      flash[:notice] = "Signed in!"
    else
      redirect_to root_path
      flash[:alert] = "Failed :("
    end
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
end
