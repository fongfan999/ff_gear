class Product < ApplicationRecord
  attr_accessor :rejected_ids
  
  has_many :attachments, dependent: :delete_all
  belongs_to :buyer, class_name: "User"
  belongs_to :category
  
  validates :name, presence: true, length: { minimum: 5, maximum: 60 }
  validates :description, presence: true, length: { minimum: 20, maximum: 500 }

  def color
    category.color
  end
end
