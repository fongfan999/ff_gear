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
  validates :name, presence: true, length: { minimum: 2 ,maximum: 45 },
    format: { with: /\A\D*\z/ }
  validates :username, presence: true, length: { minimum: 2 ,maximum: 20 },
    uniqueness: { case_sensitive: false }, format: {
      with: /(?=\A[a-z\d]+\z)(?=\A((?!admin).*)|(admin.)\z)/i,
      message: "chỉ được phép chứa ký tự và số"
    }, on: :update

  mount_uploader :avatar, AvatarUploader

  acts_as_commontator

  after_create :create_username
  after_create :create_profile

  self.per_page = 10

  scope :search, -> (q) do
    username_query = q[1..-1]
    email_query = q.split.join
    name_query = q[1..-1].split.uniq

    result = search_by('username', username_query)
    result += search_by('email', email_query)
    # Search each word
    name_query.each do |name|
      result += search_by('name', name)
    end

    result
      .each_with_object(Hash.new(0)) { |obj, h|h[obj] += 1 } # Count frequency
      .sort_by { |obj, size| -size } # Sort descending
      .map(&:first) # Remove size, get object only
  end

  scope :search_by, -> (attr, q) do
    where("lower(#{attr}) LIKE ?", "%#{q.mb_chars.downcase.to_s}%")
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

  def self.admin_users
    where(admin: true)
  end

  def self.super_user
    find_by_email('fongfan999@gmail.com')
  end

  def self.sent_notifications_from_admins(content)
    find_each do |user|
      user.get_notification(nil, nil, content, nil) unless user.admin?
    end

    # Message only (System)
    User.super_user
      .get_notification(nil, nil, "Đã gửi xong thông báo: #{content} tag", nil)
  end

  def self.sent_report_to_admins(post, commenter, report)
    User.find_each do |user|
      if user.admin?
        user.get_notification(post, commenter, report.name, nil)
      end
    end
  end

  # For chart creation purpose only
  def self.new_users_chart(type, provider = 'google_oauth2')
    grouped_by_week = User.order(created_at: :desc)
      .group_by { |u| u.created_at.beginning_of_week }
      .take(5) # limit 5 weeks
      .sort { |x, y| x[0] <=> y[0] } # sort asc
    
    if type == "label"
      return grouped_by_week.map { |label, data| label.strftime('%d/%m') }
    else
      result_data = []

      grouped_by_week.each do |label, data|
        result_data << data.select { |d| d['provider'] == provider }.length
      end

      return result_data
    end
  end

  def self.providers_chart
    facebook_counter = where(provider: 'facebook').count

    [facebook_counter, User.count - facebook_counter]
  end

  def self.roles_chart
    admin_counter = admin_users.count

    [admin_counter, User.count - admin_counter]
  end

  def self.login_user_count_chart(type)
    milestone = 7.days.ago.beginning_of_day
    recent_users = User.where('current_sign_in_at > ?', milestone)

    labels =  []
    i = 0
    while i < 7
      labels << (milestone += 1.days).strftime('%d/%m')
      i += 1
    end

    return labels if type == "label"

    # type = 'data'
    # group by current_sign_in_at and get label & users size
    result = recent_users
      .group_by { |u| u.current_sign_in_at.beginning_of_day }
      .map { |label, data| [label.strftime('%d/%m'), data.size] }

    # Create arary with 0 as default
    result_data = Array.new(7, 1)
    result.each do |obj|
      # label: obj[0]
      # data: obj[1]

      # Update data value
      if labels.include?(obj[0])
        index = labels.find_index(obj[0])
        result_data[index] = obj[1] + 1
      end
    end

    return result_data
  end
  # End chart creation

  # Don't store password
  def password_required?
    false
  end

  def favorite?(post)
    favorites.exists?(post.id)
  end

  def recent_notifications
    notifications.includes(:commenter).order(created_at: :desc).limit(15)
  end

  def get_notification(post, commenter, message, comment_id)
    Notification.find_or_create_by(user_id: self.id, post: post,
      commenter: commenter, content: message, comment_id: comment_id)
  end

  def mark_all_notifications_as_read
    notifications.each(&:mark_as_read)
  end

  # For super user only
  def update_token(param)
    pass = param[:password]
    token = param[:access_token]

    return unless self.valid_password?(pass)

    self.update(access_token: token)
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
end
