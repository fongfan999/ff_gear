class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.search(params.fetch("q", "").dup)
      .paginate(page: params[:page], per_page: 12)
  end

  def change_role
    @user = User.find(params[:id])

    if @user == User.super_user
      @message = "Không thể thay đổi vai trò của người dùng này"
    else
      @user.toggle!(:admin)
    end

    respond_to do |format|
      format.js
    end
  end

  def show_chart
    respond_to do |format|
      format.js
    end
  end
end
