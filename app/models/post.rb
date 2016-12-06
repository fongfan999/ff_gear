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
  validates :price, presence: true , numericality: { greater_than: 1000 }

  geocoded_by :address, lookup: :google

  after_validation :geocode, if: :should_save?
  after_save :geoword, if: :should_save?
  after_create :assign_user_address

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

  scope :search, -> (q) do
    return Post.all if q.blank?
    
    where("upper(title) LIKE '%#{q.upcase}%'")
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

  scope :filter, -> (filter) do
    # There are 3 criteria: sort, category_ids, price_range
    sort = filter.fetch(:sort, nil)
    category_ids = filter.fetch(:category_ids, nil)
    price_range = filter.fetch(:price_range, nil)

    Rails.logger.debug "---- #{self.count}"
    # Get current scope value for the first time
    result = custom_sort(sort)

    result = result.filter_categories(category_ids) unless category_ids.nil?
    result = result.filter_price_range(price_range) unless price_range.nil?
  end

  scope :max_price, -> { maximum(:price) }
  scope :min_price, -> { minimum(:price) }

  self.per_page = 4

  def tag_names=(names)
    @tag_names = names
    self.tags.delete_all
    names.split(",").delete_if(&:blank?).each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  def tag_names_as_string
    tags.any? ? tags.map(&:name).join(", ") : ""
  end

  def related_posts
    Category.find(self.category_id).posts.where.not(id: self.id).limit(5)
  end

  def first_attachment
    attachments.first.file.url
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
end
