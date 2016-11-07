class UsersController < ApplicationController
  before_action :set_user

  def show
  end

  def edit_avatar
    respond_to do |format|
      format.js
    end
  end

  def update
    if @user.update(avatar_params)
      flash[:notice] = "Thành công"
      redirect_to @user
    else
      flash.now[:alert] = "Loại ảnh không phù hợp"
      render :show
    end
  end

  def edit_name
    respond_to do |format|
      format.js
    end
  end

  def favorite_posts
    @favorite_posts = @user.favorites
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def avatar_params
    user_hash = params.fetch(:user, nil)

    user_hash.nil? ? {} : user_hash.permit(:avatar, :name)
  end
end
