class Zenvia < Api
  attr_accessor :number, :message, :id, :aggregate_id, :account_name

  def initialize(number, message, id, aggregate_id, account_name)
    @number = number
    @message = message
    @id = id
    @aggregate_id = aggregate_id
    @account_name = account_name[0..19]
  end

  def self.send_sms(number, message, id, aggregate_id, account_name)
    Zenvia.new(number, message, id, aggregate_id, account_name).send_sms
  end

  def send_sms
    connection.post("/services/send-sms", body.to_json)
  end

  private

    def body
      {
        sendSmsRequest: {
          from: account_name,
          to: number,
          msg: message,
          callbackOption: "ALL",
          id: id,
          aggregateId: aggregate_id
        }
      }
    end

    def base_url
      "https://api-rest.zenvia360.com.br"
    end

    def base_options
      @options ||= {
        basic_auth: { user: ENV['ZENVIA_USER'], password: ENV['ZENVIA_PASSWORD'] }
      }
    end

end