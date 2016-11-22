module UsersHelper
  def page_owner?(user)
    return false unless user_signed_in?
    
    current_user.id == user.id
  end
end
