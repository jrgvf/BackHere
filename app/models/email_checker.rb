class EmailChecker
  attr_accessor :email

# I'm using QuickEmailVerification API
# QEV_KEY is the key for BackHere in QuickEmailVerification
# Limit of 100 Verification per day for free 

  def initialize(email)
    @email = email
  end

  def self.check_email(email)
    EmailChecker.new(email).check_email
  end

  def check_email
    options = { params: { "email" => email } }
    connection.get("/v1/verify", options)
  end

  private

    def connection
      @connection ||= BaseConnection.new("http://api.quickemailverification.com", options)
    end

    def options
      @options ||= {
        parallel: false,
        timeout: 5,
        open_timeout: 5,
        params: base_params
      }
    end

    def base_params
      { "apikey" => "#{ENV['QEV_KEY']}" }
    end

end