module ApplicationHelper
  def back_link
    request.referer || root_path
  end
end
