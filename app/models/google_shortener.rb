class GoogleShortener
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def self.short_url(url)
    GoogleShortener.new(url).parse_url
  end

  def parse_url
    response = connection.post("/urlshortener/v1/url", {longUrl: url}.to_json)
    if response.status == 200
      response.body["id"]
    else
      raise StandardError.new("Não foi possível encurtar a url. Error: #{response.body["error"]}")
    end
  end

  private

    def connection
      @connection ||= BaseConnection.new("https://www.googleapis.com", options)
    end

    def options
      @options ||= {
        params: base_params
      }
    end

    def base_params
      { "key" => "#{ENV['GOOGLE_KEY']}" }
    end

end