class Tag < ApplicationRecord
  def self.junks
    tag_ids_in_use = PostTag.select(:tag_id).distinct.map(&:tag_id)
    where.not(id: tag_ids_in_use)
  end
end
