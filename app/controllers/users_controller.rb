require 'will_paginate/array'
class UsersController < ApplicationController
  before_action :set_user, except: [:profile, :notifications]

  rescue_from ActionController::UrlGenerationError , with: :not_persisted

  def profile
    @user = User.find_by_username(params[:username])

    @profile = @user.should_create_profile?
  end

  def show
    redirect_to user_profile_path(@user.username)
  end

  def edit_avatar
    respond_to do |format|
      format.js
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Thành công"
      redirect_to user_profile_path(@user.username)
    else
      flash.now[:alert] = "Thông tin không hợp lệ"
      render :show
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def favorite_posts
    @favorite_posts = @user.favorites.paginate(page: params[:page])
  end

  def notifications
    authenticate_user!

    @notifications = current_user.notifications.order(created_at: :desc)

    @notification_days = @notifications.group_by { |n|
      n.created_at.beginning_of_day
    }.to_a.paginate(:page => params[:page], :per_page => 5)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar, :name, :username)
  end

  def not_persisted
    flash[:alert] = "Người dùng không tồn tại"
    redirect_to root_path
  end
end
