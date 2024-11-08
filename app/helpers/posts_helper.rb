module PostsHelper
  def display_time(posted_time)
    if Time.current - posted_time < 24.hours
      "#{time_ago_in_words(posted_time)} ago"
    else
      I18n.l(posted_time, format: :default)
    end
  end
end
