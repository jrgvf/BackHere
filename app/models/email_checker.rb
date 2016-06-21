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
    result = Hash.new
    begin
      response = get(email)
      result = JSON.parse(response.body) rescue {}
      result["status"] = response.status
    rescue StandardError => ex
      result["status"] = 500
      result["error"] = ex.message
    end
    result
  end

  private

    def get(email)
      con.get do |req|
        req.url "/v1/verify"
        req.headers["Content-Type"]   = "application/json"
        req.headers["Accept"]         = "application/json"
        
        req.params['email']           = "#{email}"
        req.params['apikey']          = "#{ENV['QEV_KEY']}"
      end
    end

    def con
      if ENV['RAILS_ENV'] == "test"
        @con = Faraday.default_connection
      else
        @con = Faraday.new(:url => "http://api.quickemailverification.com") do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end
    end
end