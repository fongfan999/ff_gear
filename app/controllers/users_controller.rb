class UsersController < ApplicationController
  before_action :set_user, only: [:show, :change_avatar]

  def show
  end

  def change_avatar
    if @user.update(avatar_params)
      flash[:notice] = "Thành công"
      redirect_to @user
    else
      flash.now[:alert] = "Loại ảnh không phù hợp"
      render :show
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def avatar_params
    user_hash = params.fetch(:user, nil)

    user_hash.nil? ? {} : user_hash.permit(:avatar)
  end
end
