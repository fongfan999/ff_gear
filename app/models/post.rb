class Post < ApplicationRecord
  NO_LIMIT = 999999
  
  attr_accessor :tag_names
  attr_accessor :rejected_ids
  attr_accessor :report_id
  
  has_many :attachments, dependent: :delete_all
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User", foreign_key: "buyer_id"
  belongs_to :category
  has_and_belongs_to_many :tags, uniq: true
  
  validates :title, presence: true, length: { minimum: 5, maximum: 35 }
  validates :address, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, presence: true, length: { minimum: 20, maximum: 500 }
  validates :category_id, presence: true
  validates :price, presence: true,
    inclusion: { in: 1000..100000000, message: "số tiền không hợp lệ" }

  geocoded_by :address, lookup: :google

  after_validation :geocode, if: :should_save?
  after_save :geoword, if: :should_save?
  after_create :assign_user_address
  after_create :post_to_facebook_page

  acts_as_commontable

  scope :exclude_current_user, -> (user) do
    not_sold_posts = where(sold: false)
    
    user ? not_sold_posts.where.not(buyer_id: user.id) : not_sold_posts
  end

  scope :custom_sort, -> (sort_param) do
    return order(created_at: :desc) if sort_param.blank?

    sort_column = sort_param.split(/asc|desc/).join
    sort_direction = sort_param.last(sort_param.length - sort_column.length)

    # Make sure query is running if param is not valid
    sort_column = "created_at" unless Post.column_names.include?(sort_column)
    sort_direction = "desc" unless %w[asc desc].include?(sort_direction)

    order("#{sort_column} #{sort_direction}")
  end

  scope :search, -> (q, sort_param = nil) do
    return Post.all if q.blank?

    result = search_by('description', q)

    # result += search_by('address', q)
    
    q.split.each_with_index do |word, index|
      # Normal search
      if q !~ /\A#/
        result += search_by_category(word) if index.zero?
        result += search_by('title', word)
        result += search_by('address', word)
      end
      
      result += search_by_tag(word.delete('#')) # remove hashtag
    end


    if (sort_param.nil? || sort_param == "relevance")
      return result
        .each_with_object(Hash.new(0)) { |obj, h|h[obj] += 1 } #Count frequency
        .sort_by { |obj, size| -size } # Sort frequency as descending
        .map(&:first) # Remove size, get object only
    else
      return result.uniq
    end
  end

  scope :search_by, -> (attr, q) do
    where("lower(#{attr}) LIKE ?", "%#{q.mb_chars.downcase.to_s}%")
  end

  scope :search_by_tag, -> (q) do
    # Match entire words
    # Don't need to down case query when using regex
    joins(:tags).where("tags.name ~* ?", "\\y#{q}\\y")
  end

  scope :search_by_category, -> (q) do
    joins(:category)
      .where("lower(categories.name) LIKE ?", "%#{q.mb_chars.downcase.to_s}%")
  end

  scope :filter, -> (filter) do
    # There are 3 criteria: sort, category_ids, price_range, state
    sort = filter.fetch(:sort, nil)
    category_ids = filter.fetch(:category_ids, nil)
    price_range = filter.fetch(:price_range, nil)
    state = filter.fetch(:state, nil)

    # Get current scope value for the first time
    result = custom_sort(sort)

    result = result.filter_categories(category_ids) unless category_ids.nil?
    result = result.filter_price_range(price_range) unless price_range.nil?
    result = result.filter_state(state) unless state.nil?

    result
  end

  scope :filter_categories, -> (category_ids) do
    where(category_id: category_ids) if category_ids.present?
  end

  scope :filter_price_range, -> (price_range) do
    # Convert string to array
    price_range_array = price_range.split(',').map do |number_with_point| 
      number_with_point.split('.').join.to_i * 1000 
    end

    # Ensure price_range has 2 values only
    return unless price_range_array.size == 2

    # Get min and max price
    min_price = price_range_array[0]
    max_price = price_range_array[1]
    # Ensure min_price always less than max_price
    return unless min_price < max_price

    # Run query
    where("price BETWEEN ? AND ?", min_price, max_price)
  end

  scope :filter_state, -> (state) do
    where(sold: state)
  end

  scope :max_price, -> { maximum(:price) }
  scope :min_price, -> { minimum(:price) }

  self.per_page = 12

  def self.exclude_sold_posts
    where(sold: false)
  end

  # For chart creation purpose only
  def self.categories_chart
    group(:category_id).count.map(&:last)
  end

  def self.state_chart
    group(:sold).order(:sold).count.map(&:last)
  end
  # End chart creation

  def tag_names=(names)
    @tag_names = names
    # Delete and create new
    self.tags.delete_all

    names.split(",").delete_if(&:blank?).take(5).each do |name|
      if name.length < 20
        # Resolve UTF-8
        self.tags << Tag.find_or_initialize_by(
          name: name.strip.mb_chars.downcase.to_s
        )
      end
    end
  end

  def tag_names_as_string
    tags.any? ? tags.map(&:name).join(", ") : ""
  end

  def related_posts(num = 5)
    result = Post.where.not(id: id).exclude_sold_posts.search(title).take(num)

    if result.size < num
      # Not self and above result
      result += category.posts.where.not(id: (result.map(&:id) << id))
        .exclude_sold_posts.take(num - result.size)
    end

    result
  end

  def first_attachment
    attachments.first.file.url
  end

  def state
    sold? ? "Đã bán" : "Chưa bán"
  end

  private

  def should_save?
    address.present? && address_changed?
  end

  def geoword
    if geo = Geocoder.search(self.address).first
      address = []

      if geo.address_components.size > 3
        address = []
        address << geo.address_components[-3]["long_name"]
        address << geo.address_components[-2]["long_name"]
      else
        address << geo.sub_state if geo.sub_state.present?
        address << geo.state if geo.state.present?
      end
      
      permitted_address =  if address.length > 1
        address.join(', ')
      else
        address.first
      end

      update_columns(address: permitted_address)
    end
  end

  def assign_user_address
    owner.profile.update(address: self.address) if owner.profile.address.blank?
  end

  def helpers
    ActionController::Base.helpers
  end

  def post_to_facebook_page
    @user_graph = Koala::Facebook::API.new(User.super_user.access_token)
    page_token = @user_graph.get_page_access_token(579851348889688)
    picture_link = if Rails.env.production? 
      self.first_attachment
    else
      'https://digitalcrack.files.wordpress.com/2014/12/wpid-tech-beats-headphones-1.jpg'
    end

    @graph = Koala::Facebook::API.new(page_token)
    @graph.put_wall_post("#{title} - #{helpers.number_to_currency(price)}\n#{description}", {
      name: title,
      caption: "FOXFIZZ.COM",
      description: address,
      link: Rails.application.routes.url_helpers.post_url(self), 
      picture: picture_link
    })
  end

  handle_asynchronously :post_to_facebook_page,
                          run_at: Proc.new { 5.minutes.from_now }
end
