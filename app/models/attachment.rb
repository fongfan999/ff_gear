class Attachment < ApplicationRecord
  mount_uploader :file, AttachmentUploader

  scope :pending, -> (created_ids) { where(id: created_ids) }
  
  scope :unlink_post, -> (junk_ids) do
    return if junk_ids.blank?

    junk_ids = JSON.parse(junk_ids) if junk_ids.is_a? String
    where(id: junk_ids).update_all(post_id: nil)
  end

  def self.junks
    where(post_id: nil)
  end
end

