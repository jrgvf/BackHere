class Api

  private

    def connection
      @connection ||= BaseConnection.new(base_url, base_options)
    end

    def base_url
      raise NotImplementedError
    end

    def base_options
      raise NotImplementedError
    end
end