module ApplicationHelper
  def real_user
    (current_user && current_user.anonymous == false)
  end

  def anonymous_user
    (current_user && current_user.anonymous == true)
  end
end
