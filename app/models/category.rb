class Category < ApplicationRecord
  has_many :posts, dependent: :delete_all

  validates :name, :icon, presence: true
end
