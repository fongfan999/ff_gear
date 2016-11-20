class User < ApplicationRecord
  # Include default devise modules. Others available ardebuggerconfirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :validatable,
        :rememberable

  has_many :posts, foreign_key: 'buyer_id', dependent: :delete_all
  has_and_belongs_to_many :favorites, join_table: :posts_users,
    class_name: "Post"
  has_many :notifications
  has_one :profile, dependent: :delete

  validates :avatar, presence: true,
    format: { with: /\A.*\.(png|jpg|jpeg|gif)\z/ }, on: :update
  validates :name, presence: true, length: { minimum: 2 ,maximum: 45 }
  validates :username, presence: true, length: { minimum: 2 ,maximum: 20 },
    uniqueness: { case_sensitive: false }, format: { with: /\A[a-z\d]+\z/i,
    message: "chỉ được phép chứa ký tự và số" }, on: :update

  mount_uploader :avatar, AvatarUploader

  acts_as_commontator

  after_create :create_username
  after_create :create_profile

  # Don't store password
  def password_required?
    false
  end

  def self.from_omniauth(auth)
    user =  User.where(provider: auth.provider, uid: auth.uid)
      .first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.remote_avatar_url = auth.info.image.sub('http://', 'https://')
    end

    if user.profile
      # Provider: facebook
      if auth.provider == "facebook"
        user.profile.update(fb_link: auth.extra.raw_info.link)
      else
        # Provider: google_oauth2
        user.profile.update(gg_link: auth.extra.raw_info.profile)
      end
    end
    
    # return user
    user 
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

  def recent_posts
    ( (posts.count < 5)  ? posts : posts.limit(5) ).order(created_at: :desc)
  end

  private

  def create_username
    self.update(username: "user#{id}")
  end

  # def create_profile
  #   self.create_profile
  # end
end
