class Google < Api

  private

    def base_url
      "https://www.googleapis.com"
    end

    def base_options
      @options ||= {
        params: { "key" => "#{ENV['GOOGLE_KEY']}" }
      }
    end

end