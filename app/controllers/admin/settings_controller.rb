class Admin::SettingsController < Admin::ApplicationController
  def index
    @junk_tags_count = Tag.junks.count
    @junk_attachments_count = Attachment.junks.count
    @notice_by_admins = 1
    @admin_access_token = APP_CONFIG['admin_access_token'].last(2)
  end

  def clean_junk_tags
    unless Delayed::Job.find_by_queue("clean_junk_tags")
      Tag
        .delay(run_at: 30.minutes.from_now, queue: "clean_junk_tags")
        .clean_junks
    end

    head :ok
  end

  def clean_junk_attachments
    unless Delayed::Job.find_by_queue("clean_junk_attachments")
      Attachment
        .delay(run_at: 30.minutes.from_now, queue: "clean_junk_attachments")
        .clean_junks
    end

    head :ok
  end

  def send_notifications
    content = notification_params[:content]
    delay_time = notification_params[:delay_time].to_i

    if content && delay_time
      User.delay(run_at: delay_time.minutes.from_now)
        .sent_notifications_from_admins(content)
      @message = "Đang gửi thông báo ..."
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:content, :delay_time)
  end
end
