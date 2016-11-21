module UsersHelper
  def page_owner?(user)
    current_user.id == user.id
  end
end
