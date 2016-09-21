class Product < ApplicationRecord
  validates :name, :description, presence: true

  mount_uploaders :attachments, AttachmentUploader
end
