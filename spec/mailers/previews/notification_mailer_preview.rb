# Preview all emails at http://localhost:3000/rails/mailers/home_message_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/preview
  def preview
    notification = Notification.all.entries.first
    NotificationMailer.build_message(notification.id.to_s, 'jrgvf@cin.ufpe.br')
  end

end
