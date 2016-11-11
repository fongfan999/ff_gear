class UsersController < ApplicationController
  before_action :set_user, except: [:notifications]

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
      flash.now[:alert] = "Thông tin không hợp lệ"
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

  def notifications
    @notifications = current_user.notifications.order(created_at: :desc)
    @notification_days = @notifications.group_by { |n|
      n.created_at.beginning_of_day
    }
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
