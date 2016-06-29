class PhoneChecker
  attr_accessor :phone

# I'm using Neutrino API (Phone Validate)
# NEUTRINO_USER is the user for BackHere in Neutrino API
# NEUTRINO_KEY is the key for BackHere in Neutrino API
# Limit of 25 Verification per day for free (Phone Validate)

  def initialize(phone)
    @phone = phone
  end

  def self.check_phone(phone)
    PhoneChecker.new(phone).check_phone
  end

  def check_phone
    options = { params: { "country-code" => "BR", "number" => phone } }
    connection.get("/phone-validate", options)
  end

  private

    def connection
      @connection ||= BaseConnection.new("https://neutrinoapi.com", options)
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
      { "user-id" => "#{ENV['NEUTRINO_USER']}", "api-key" => "#{ENV['NEUTRINO_KEY']}" }
    end

end