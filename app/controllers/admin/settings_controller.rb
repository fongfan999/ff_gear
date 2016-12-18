class Admin::SettingsController < Admin::ApplicationController
  def index
    @junk_tags = Tag.junks
    @junk_attachments = Attachment.junks
    @notice_by_admins = 15
    @admin_access_token = APP_CONFIG['admin_access_token'].last(2)
  end
end
