# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create :send_email

  private
  def send_email
    mentioned_users.each do |mentioned_user|
      MentionMailer.send_mention_notification(mentioned_user, user).deliver_now
    end
  end

  def mentioned_users
    return [] if content.blank? # コメントがからの場合、空の配列を返す

    usernames = content.scan(/@([\w一-龥ぁ-んァ-ヶー]+)/).flatten.map(&:downcase) # ユーザ名を小文字に変換
    User.where('LOWER(account_name) IN (?)', usernames) # 大文字小文字を無視して検索
  end
end
