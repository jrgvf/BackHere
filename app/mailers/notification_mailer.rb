class NotificationMailer < ApplicationMailer
  layout 'backhere/notification'

  def build_message(notification_id, email_address)
    @notification = Notification.find_by(id: notification_id)
    @account      = @notification.account
    @customer     = @notification.customer

    mail to: email_address, subject: "[BackHere] - #{@account.name} gostaria de saber sua opinião"
  end
end
