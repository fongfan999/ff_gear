class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(sign_in_count: :desc).paginate(page: params[:page], per_page: 10)
  end

  def change_role
    @user = User.find(params[:id])
    @user.toggle(:admin)

    if !@user.admin? && User.admin_users.count == 1
      @message = "Đây là quản trị viên cuối cùng"
    else
      @user.save
    end

    respond_to do |format|
      format.js
    end
  end
end
