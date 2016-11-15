class ProfilesController < ApplicationController
  def update
    profile = Profile.find(params[:id])
    profile.update(params.require(:profile).permit(:phone, :address, :gender,
      :birthday, :fb_link, :gg_link))
    redirect_to user_profile_path(profile.user.username)
  end
end
