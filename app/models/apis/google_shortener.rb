class GoogleShortener < Google
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def self.shorten(url)
    GoogleShortener.new(url).shorten
  end

  def self.expand(url)
    GoogleShortener.new(url).expand
  end

  def shorten
    response = connection.post("/urlshortener/v1/url", {longUrl: url}.to_json)
    if response.status == 200
      response.body["id"]
    else
      raise StandardError.new("Não foi possível encurtar a url. Error: #{response.body["error"]}")
    end
  end

  def expand
    response = connection.get("/urlshortener/v1/url", {params: {shortUrl: url}})
    if response.status == 200 && response.body["status"] == "OK"
      response.body["longUrl"]
    else
      raise StandardError.new("Não foi possível recuperar a url. Error: #{response.body["error"]}")
    end
  end

end