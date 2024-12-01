class TimelinesController < ApplicationController
  before_action :authenticate_user!

  def show
    @posts = Post.joins(:likes)
                 .where(created_at: 24.hours.ago..Time.current)
                 .select("posts.*, COUNT(likes.id) AS likes_count")
                 .group("posts.id")
                 .having("SUM(CASE WHEN likes.user_id = ? THEN 1 ELSE 0 END) > 0", current_user.id)
                 .order("likes_count DESC")
                 .limit(5)
  end
end
