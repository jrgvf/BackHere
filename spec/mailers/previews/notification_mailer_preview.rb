# Preview all emails at http://localhost:3000/rails/mailers/home_message_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/preview
  def preview
    NotificationMailer.build_message(Account.all.entries.last.id.to_s, 'teste', 'jrgvf@cin.ufpe.br')
  end

end
