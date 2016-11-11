class AddCommentIdToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :comment_id, :integer
  end
end
