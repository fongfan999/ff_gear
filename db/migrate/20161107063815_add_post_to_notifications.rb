class AddPostToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_reference :notifications, :post, foreign_key: true
  end
end
