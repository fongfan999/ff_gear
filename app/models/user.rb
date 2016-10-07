class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :validatable

  def password_required?
    false
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid).permit!).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.avatar = auth.info.image
    end
  end
end
