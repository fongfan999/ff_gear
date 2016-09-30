class Attachment < ApplicationRecord
  # belongs_to :product

  mount_uploader :file, AttachmentUploader

  scope :pending, -> (created_ids) { where(id: created_ids) }
  
  scope :clean_junks, -> (junk_ids) do
    return if junk_ids.blank?

    junk_ids = JSON.parse(junk_ids) if junk_ids.is_a? String
    where(id: junk_ids).delete_all
  end
end

