class Attachment < ApplicationRecord
  # belongs_to :product

  mount_uploader :file, AttachmentUploader

  scope :pending, -> (rejected_ids) do
    created_attachments = where(product_id: nil)
    if rejected_ids.present?
      created_attachments.where.not(id: JSON.parse(rejected_ids)) 
    else
      created_attachments
    end
  end
  
  scope :clean_junks, -> { where(product_id: nil).delete_all }
end

