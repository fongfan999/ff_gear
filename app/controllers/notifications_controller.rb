class NotificationsController < ApplicationController
  def mark_all_as_read
    current_user.mark_all_notifications_as_read

    respond_to do |format|
      format.js
    end
  end

  def mark_toggle_status
    @notification = Notification.find(params[:id])
    @notification.mark_toggle_status

    respond_to do |format|
      format.js
    end
  end
end
