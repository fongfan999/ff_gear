class Attachment < ApplicationRecord
  # belongs_to :product

  mount_uploader :file, AttachmentUploader

  scope :pending, -> (attachment_ids) { where(id: attachment_ids) }
end

