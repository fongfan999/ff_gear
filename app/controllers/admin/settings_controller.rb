class Admin::SettingsController < Admin::ApplicationController
  def index
    @super_user = User.super_user

    @junk_tags_count = Tag.junks.count
    @junk_attachments_count = Attachment.junks.count
    @queue_jobs_count = Delayed::Job.where(queue: "send_notifications").count
    @admin_access_token = @super_user.access_token.last(2)
  end

  def clean_junk_tags
    unless Delayed::Job.find_by_queue("clean_junk_tags")
      Tag.delay(run_at: 30.minutes.from_now, queue: "clean_junk_tags")
        .clean_junks
    end

    head :ok
  end

  def clean_junk_attachments
    unless Delayed::Job.find_by_queue("clean_junk_attachments")
      Attachment.delay(
        run_at: 30.minutes.from_now,
        queue: "clean_junk_attachments"
      ).clean_junks
    end

    head :ok
  end

  def send_notifications
    content = notification_params[:content]
    delay_time = notification_params[:delay_time].to_i

    if content && delay_time
      User.delay(
        run_at: delay_time.minutes.from_now,
        queue: "send_notifications"
      ).sent_notifications_from_admins(content)

      @message = "Đang gửi thông báo ..."
    end

    respond_to do |format|
      format.js
    end
  end

  def update_access_token
    @super_user = User.super_user
  
    if @super_user.update_token(super_user_params)
      flash[:notice] = "Cập nhật token thành công"
    else
      flash[:alert] = "Mật khẩu không đúng. Vui lòng thử lại!"
    end

    redirect_to admin_settings_path
  end

  private

  def notification_params
    params.require(:notification).permit(:content, :delay_time)
  end

  def super_user_params
    params.require(:user).permit(:password, :access_token)
  end
end
