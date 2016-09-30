class Product < ApplicationRecord
  COLORS = %w(#5b6abf #679e37 #e53935 #414141 #8c6d62 #029ae4 #ff6f42 #778f9b 
    #00abc0 #378d3b #00887a #1d87e4 #eb3f79 #f8a724)

  attr_accessor :rejected_ids
  
  has_many :attachments, dependent: :delete_all
  validates :name, :description, presence: true

  def color
    Product::COLORS[rand(Product::COLORS.length + 1)]
  end
end
