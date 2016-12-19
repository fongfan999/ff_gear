class Profile < ApplicationRecord
  belongs_to :user

  validates :phone, allow_blank: true, format: { with: /\A\z|\A\d{10,11}\z/ }
  validates :address, allow_blank: true, length: { minimum: 5, maximum: 60 }
  validates :fb_link, :gg_link, allow_blank: true,
    format: { with: /\Ahttps:\/\// }
end
