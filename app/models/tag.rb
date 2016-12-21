class Tag < ApplicationRecord
  def self.junks
    tag_ids_in_use = PostTag.select(:tag_id).distinct.map(&:tag_id)
    where.not(id: tag_ids_in_use)
  end

  def self.clean_junks
    sum = junks.delete_all

    # Message only (System)
    User.super_user.get_notification(nil, nil, "Đã dọn xong #{sum} tag", nil)
  end
end
