class ProfilesController < ApplicationController
  def update
    profile = Profile.find(params[:id])
    profile.update(params.require(:profile).permit(:phone, :address,
      :fb_link, :gg_link))

    flash[:notice] = "Cập nhật thành công"
    redirect_to user_profile_path(profile.user.username)
  end
end
