class Product < ApplicationRecord
  validates :name, :description, presence: true
end
