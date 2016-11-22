class Admin::ApplicationController < ApplicationController
  before_action :authorize_admin!

  def index
    # render layout: false
  end

  private

  def authorize_admin!
    authenticate_user!

    unless current_user.admin?
      flash[:alert] = "Bạn không có quyền truy cập chức năng này"
      redirect_to market_path      
    end
  end
end
