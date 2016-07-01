class NotificationMessenger
  attr_accessor :phone, :message, :token, :aggregate_id, :account_name

  def initialize(phone, message, id, aggregate_id, account_name)
    @phone = phone
    @message = message
    @id = id
    @aggregate_id = aggregate_id
    @account_name = account_name[0..19]
  end

  def self.build_messenger(notification, phone, index)
    account = notification.account

    url = Rails.application.routes.url_helpers.backhere_notification_url(token: notification.token)
    short_url = GoogleShortener.short_url(url)
    message = "Sua opinião é muito importante e gostaríamos de saber como foi sua experiência com a nossa empresa, acesse: #{short_url}"

    NotificationMessenger.new(phone, message, "#{notification.token}#{index}", account.aggregate_id, account.name)
  end

  def deliver
    connection.post("/services/send-sms", body)
  end

  private

    def connection
      @connection ||= BaseConnection.new("https://api-rest.zenvia360.com.br", { basic_auth: { user: ENV['ZENVIA_USER'], password: ENV['ZENVIA_PASSWORD'] } })
    end

    def body
      {
        sendSmsRequest: {
          from: "#{account_name}",
          to: phone,
          msg: message,
          callbackOption: "NONE",
          id: id,
          aggregateId: aggregate_id
        }
      }.to_json
    end

end