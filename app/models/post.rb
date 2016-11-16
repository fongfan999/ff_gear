class Post < ApplicationRecord
  attr_accessor :rejected_ids
  
  has_many :attachments, dependent: :delete_all
  has_and_belongs_to_many :users, uniq: true
  belongs_to :owner, class_name: "User", foreign_key: "buyer_id"
  belongs_to :category
  
  validates :title, presence: true, length: { minimum: 5, maximum: 60 }
  validates :address, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, presence: true, length: { minimum: 20, maximum: 500 }
  validates :category_id, presence: true
  validates :price, presence: true, numericality: { greater_than: 1000 }

  geocoded_by :address, lookup: :google

  after_validation :geocode, if: :should_save?
  after_save :geoword, if: :should_save?
  after_save :assign_user_address, on: :create

  acts_as_commontable

  self.per_page = 3

  def color
    category.color
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
    profile = owner.should_create_profile?
    profile.update(address: self.address) if profile.address.blank?
  end
end
