require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :set_user, except: [:profile, :favorite_posts,:notifications]
  before_action :authenticate_user!, except: [:profile, :show]

  def profile
    @user = User.find_by_username(params[:username])

    if @user
      @profile = @user.profile
      @recent_posts = @user.recent_posts
    else
      not_persisted
    end
  end

  def show
    redirect_to user_profile_path(@user.username)
  end

  def edit_avatar
    authorize @user

    respond_to do |format|
      format.js
    end
  end

  def update
    authorize @user

    if @user.update(user_params)
      flash[:notice] = "Cập nhật thành công"
      redirect_to user_profile_path(@user.username)
    else
      flash.now[:alert] = "Thông tin không hợp lệ"
      render :show
    end
  end

  def edit
    authorize @user

    respond_to do |format|
      format.js
    end
  end

  def favorite_posts
    @favorite_posts = current_user.favorites.paginate(page: params[:page])
  end

  def notifications
    @notifications = current_user.notifications.order(created_at: :desc)

    @notification_days = @notifications.group_by { |n|
      n.created_at.beginning_of_day
    }.to_a.paginate(:page => params[:page], :per_page => 5)
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:avatar, :name, :username)
  end
end
