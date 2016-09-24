class Product < ApplicationRecord
  attr_accessor :file
  has_many :attachments, dependent: :destroy
  # accepts_nested_attributes_for :attachments,
    # reject_if: lambda { |a| a[:linked].blank? }
  
  validates :name, :description, presence: true
end
