class Report < ApplicationRecord
  def self.report_collection(post)
    post.sold? ? Report.where.not(name: "Sản phẩm đã bán") : Report.all
  end
end
