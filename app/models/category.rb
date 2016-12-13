class Category < ApplicationRecord
  default_scope { order(:id) }

  has_many :posts, dependent: :delete_all

  validates :name, :icon, presence: true
end
