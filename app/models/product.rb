class Product < ApplicationRecord
  attr_accessor :rejected_ids
  has_many :attachments, dependent: :destroy
  
  validates :name, :description, presence: true
end
