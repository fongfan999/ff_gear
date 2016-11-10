class Notification < ApplicationRecord
  belongs_to :commenter, class_name: "User"
  belongs_to :user
  belongs_to :post

  def unread?
    created_at == updated_at
  end

  def mark_as_read
    touch
  end

  def mark_as_unread
    update(updated_at: created_at)
  end

  def mark_toggle_status
    unread? ? mark_as_read : mark_as_unread
  end
end
