class QuickEmailVerification < Api
  attr_accessor :email

# I'm using QuickEmailVerification API
# QEV_KEY is the key for BackHere in QuickEmailVerification
# Limit of 100 Verification per day for free 

  def initialize(email)
    @email = email
  end

  def check_email
    options = { params: { "email" => email } }
    connection.get("/v1/verify", options)
  end

  private

    def base_url
      "http://api.quickemailverification.com"
    end

    def base_options
      @options ||= {
        parallel: false,
        timeout: 5,
        open_timeout: 5,
        params: { "apikey" => "#{ENV['QEV_KEY']}" }
      }
    end

end