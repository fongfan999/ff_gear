class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :validatable,
        :rememberable

  has_many :posts, foreign_key: 'buyer_id'
  has_and_belongs_to_many :favorites, join_table: :posts_users,
    class_name: "Post"
  has_many :notifications

  validates :avatar, format: { with: /\A.*\.(png|jpg|jpeg|gif)\z/ }
  validates :name, presence: true, length: { minimum: 2 ,maximum: 45 }

  mount_uploader :avatar, AvatarUploader

  acts_as_commontator

  # Don't store password
  def password_required?
    false
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.remote_avatar_url = auth.info.image
    end
  end

  def favorite?(post)
    favorites.exists?(post.id)
  end

  def recent_notifications
    notifications.order(created_at: :desc).limit(15)
  end

  def get_notification(post, commenter, message, comment_id)    
    notification = self.notifications.build(content: message,
      comment_id: comment_id)
    notification.post = post
    notification.commenter = commenter

    notification.save
  end

  def mark_all_notifications_as_read
    notifications.each(&:mark_as_read)
  end

  def unread_counter
    notifications.select(&:unread?).count
  end
end
