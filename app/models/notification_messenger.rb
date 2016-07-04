class NotificationMessenger

  def self.deliver_now(notification, number, index)
    account = notification.account

    url = Rails.application.routes.url_helpers.backhere_notification_url(token: notification.token)
    short_url = GoogleShortener.shorten(url)
    message = "Sua opinião é muito importante e gostaríamos de saber como foi sua experiência com a nossa empresa, acesse: #{short_url}"

    Zenvia.send_sms(number, message, "#{notification.token}-#{index}", account.aggregate_id, account.name)
  end

end