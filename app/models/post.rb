class Post < ApplicationRecord
  attr_accessor :rejected_ids, :tmp_address
  
  has_many :attachments, dependent: :delete_all
  belongs_to :buyer, class_name: "User"
  belongs_to :category
  
  validates :title, presence: true, length: { minimum: 5, maximum: 60 }
  validates :address, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, presence: true, length: { minimum: 20, maximum: 500 }

  geocoded_by :address, lookup: :google

  after_validation :geocode, if: :should_save?
  after_save :test_test, if: :should_save?

  def color
    category.color
  end

  private

  def should_save?
    address.present? && address_changed?
  end

  def test_test
    if geo = Geocoder.search(self.address).first
      update_columns(address: "#{geo.sub_state}, #{geo.state}")
    end
  end
end
