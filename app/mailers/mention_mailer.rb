class MentionMailer < ApplicationMailer
  def send_mention_notification(recipient_user, sender_user)
    @recipient_user = recipient_user
    @sender_user = sender_user
    mail to: recipient_user.email, subject: '【お知らせ】メッセージがあります'
  end
end
