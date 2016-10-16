class Product < ApplicationRecord
  attr_accessor :rejected_ids
  
  has_many :attachments, dependent: :delete_all
  belongs_to :buyer, class_name: "User"
  belongs_to :category
  
  validates :name, presence: true, length: { minimum: 5, maximum: 60 }
  validates :address, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, presence: true, length: { minimum: 20, maximum: 500 }

  geocoded_by :address, lookup: :google
  reverse_geocoded_by :latitude, :longitude
  after_save :geocode, :reverse_geocode, if: :address_changed?

  def color
    category.color
  end
end
