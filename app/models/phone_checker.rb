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
    result = Hash.new
    begin
      response = get(phone)
      result = JSON.parse(response.body) rescue {}
      result["status"] = response.status
    rescue StandardError => ex
      result["status"] = 500
      result["error"] = ex.message
    end
    result
  end

  private

    def get(phone)
      con.get do |req|
        req.url "/phone-validate"
        req.headers["Content-Type"]   = "application/json"
        req.headers["Accept"]         = "application/json"

        req.params['user-id']         = "#{ENV['NEUTRINO_USER']}"
        req.params['api-key']         = "#{ENV['NEUTRINO_KEY']}"
        req.params['number']          = "#{phone}"
      end
    end

    def con
      if ENV['RAILS_ENV'] == "test"
        @con = Faraday.default_connection
      else
        @con = Faraday.new(:url => "https://neutrinoapi.com") do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end
    end
end