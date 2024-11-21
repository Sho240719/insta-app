class MentionMailer < ApplicationMailer
  def send_mention_notification(recipient_user, sender_user)
    @recipient_user = recipient_user
    @sender_user = sender_user

    subject = "#{@sender_user.account_name}さんがあなたにメッセージを送信しました"

    mail to: recipient_user.email, subject: subject
  end
end
