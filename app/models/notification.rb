class Notification < ApplicationRecord
  belongs_to :commenter, class_name: "User"
  belongs_to :user
  belongs_to :post
end
