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
  validates :price, presence: true, numericality: { greater_than: 1000 }

  geocoded_by :address, lookup: :google

  after_validation :geocode, if: :should_save?
  after_save :geoword, if: :should_save?
  after_create :assign_user_address

  acts_as_commontable

  scope :filtered, -> (user) do
    not_sold_posts = Post.where(sold: false)
    
    user ? not_sold_posts.where.not(buyer_id: user.id) : not_sold_posts
  end

  self.per_page = 4

  def tag_names=(names)
    @tag_names = names
    self.tags.delete_all
    names.split(",").delete_if(&:blank?).each do |name|
      self.tags << Tag.find_or_create_by(name: name)
    end
  end

  def tag_names_as_string
    tags.any? ? tags.map(&:name).join(", ") : ""
  end

  def related_posts
    Category.find(self.category_id).posts.where.not(id: self.id).limit(5)
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
