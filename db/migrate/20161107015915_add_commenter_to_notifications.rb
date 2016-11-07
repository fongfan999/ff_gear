class AddCommenterToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_reference :notifications, :commenter
    add_foreign_key :notifications, :users, column: :commenter_id
  end
end
