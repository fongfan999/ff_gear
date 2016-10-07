class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.persisted?
      sign_in_and_redirect user, notice: "Signed in!"
    else
      redirect_to root_path, alert: "Failed!"
    end
  end

  alias_method :facebook, :all
end
