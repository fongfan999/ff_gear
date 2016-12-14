class Category < ApplicationRecord
  default_scope { order(:id) }

  has_many :posts, dependent: :delete_all

  validates :name, :icon, presence: true

  def self.labels_7_days_ago
    milestone = 7.days.ago.beginning_of_day
    labels =  []
    i = 0

    while i < 7
      labels << (milestone += 1.days).strftime('%d/%m')
      i += 1
    end

    labels
  end

  # For chart creation purpose only
  def data_posts_chart
    milestone = 7.days.ago.beginning_of_day
    recent_posts = posts.where('created_at > ?', milestone)

    labels = Category.labels_7_days_ago
    result = recent_posts
      .group_by { |p| p.created_at.beginning_of_day }
      .sort { |x, y| x[0] <=> y[0] }
      .map { |label, data| [label.strftime('%d/%m'), data.size] }

    result_data = Array.new(7, 0)

    result.each do |obj|
      # label: obj[0]
      # data: obj[1]

      # Update data value
      if labels.include?(obj[0])
        index = labels.find_index(obj[0])
        result_data[index] = obj[1]
      end
    end

    result_data
  end
end
