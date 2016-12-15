class Admin::ApplicationController < ApplicationController
  before_action :authorize_admin!

  def index
    @top_users = User.order(sign_in_count: :desc).limit(5)
  end

  private

  def authorize_admin!
    authenticate_user!

    unless current_user.admin?
      flash[:alert] = "Bạn không có quyền thực hiện chức năng này"
      redirect_to root_path   
    end
  end
end
