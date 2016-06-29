class BaseConnection

  attr_accessor :base_url, :options

  ##
  # Initialize BaseConnection
  #
  def initialize(base_url, options = {})
    raise StandardError.new("Options must be a Hash.") unless options.is_a?(Hash)

    @base_url = base_url
    @options = options
  end

  ##
  # HTTP Method POST
  #
  def post(path, data, options = {})
    base_call(:post, path, options, data)
  end

  ##
  # HTTP Method GET
  #
  def get(path, options = {})
    base_call(:get, path, options)
  end

  ##
  # HTTP Method PUT
  #
  def put(path, data, options = {})
    base_call(:put, path, options, data)
  end

  ##
  # HTTP Method PATCH
  #
  def patch(path, data, options = {})
    base_call(:patch, path, options, data)
  end

  ##
  # HTTP Method DELETE
  #
  def delete(path, options = {})
    base_call(:delete, path, options)
  end

  ##
  # Parallel HTTP Method POST
  #
  def parallel_post(requests, options = {})
    base_parallel_call(:post, requests, options)
  end

  ##
  # Parallel HTTP Method GET
  #
  def parallel_get(requests, options = {})
    base_parallel_call(:get, requests, options)
  end

  ##
  # Parallel HTTP Method PUT
  #
  def parallel_put(requests, options = {})
    base_parallel_call(:put, requests, options)
  end

  ##
  # Parallel HTTP Method PATCH
  #
  def parallel_patch(requests, options = {})
    base_parallel_call(:patch, requests, options)
  end

  ##
  # Parallel HTTP Method DELETE
  #
  def parallel_delete(requests, options = {})
    base_parallel_call(:delete, requests, options)
  end

  private

    ##
    # Base Parallel Call of HTTP Method
    #
    def base_parallel_call(method, requests, options)
      headers = options[:headers] || {}
      params  = options[:params] || {}
      params.merge!(base_params)

      responses = Array.new

      con.in_parallel(manager) do
        requests.each do |request|
          req_headers = headers.merge(request.dig(:options, :headers) || {})
          req_params  = params.merge(request.dig(:options, :params) || {})

          req_headers = parse_options(req_headers)
          req_params  = parse_options(req_params)
          req_path    = parse_path(request[:path])
          req_data    = request[:data]

          responses << try_call(method, req_path, req_headers, req_params, req_data)
        end
      end

      responses
    end

    ##
    # Base Call of HTTP Method
    #
    def base_call(method, path, options, data = nil)
      headers = options[:headers] || {}
      params  = options[:params] || {}
      params.merge!(base_params)

      parsed_path     = parse_path(path)
      parsed_headers  = parse_options(headers)
      parsed_params   = parse_options(params)

      try_call(method, parsed_path, parsed_headers, parsed_params, data)
    end

    ##
    # Parse path for valid path
    #
    def parse_path(path)
      parsed_path = path.starts_with?("/") ? path : "/#{path}"
      parsed_path = URI.encode(parsed_path)
      URI.parse(parsed_path).to_s 
    end

    ##
    # Parse options for valid keys and values
    #
    def parse_options(options)
      parsed_options = Hash.new
      options.each do |key, value|
        parsed_key = URI.parse(URI.encode(key.to_s)).to_s
        if value.is_a?(Array)
          parsed_value = value.map { |v| URI.parse(URI.encode(v.to_s)).to_s }
        else
          parsed_value = URI.parse(URI.encode(value.to_s)).to_s
        end
        parsed_options[parsed_key] = parsed_value
      end
      parsed_options
    end

    ##
    # Make the HTTP request
    #
    def try_call(method, path, headers = {}, params = {}, data = nil)
      begin
        con.send(method) do |req|
          req.url path
          headers.each  { |key, value| req.headers[key] = value }
          params.each   { |key, value| req.params[key] = value }
          req.body = data unless data.nil?
        end
      rescue Faraday::Error => error
        response_error(method, path, error)
      end
    end

    ##
    # Define the per-connection settings
    #
    def con
      return @con unless @con.nil?

      if ENV['RAILS_ENV'] == "test"
        @con = Faraday.default_connection
      else
        @con = Faraday.new(url: base_url, headers: headers, ssl: {verify: false}) do |faraday|
          faraday.request   :url_encoded             # form-encode POST params
          faraday.response  :logger                  # log requests to STDOUT
          faraday.adapter   adapter
          faraday.options.timeout = timeout
          faraday.options.open_timeout = open_timeout

          faraday.response :json,    :content_type => /\bjson$/
          faraday.response :xml,     :content_type => /\bxml$/
          faraday.response :yaml,    :content_type => /\byaml$/
          faraday.response :marshal, :content_type => /\bmarshal$/
        end
      end
    end

    ##
    # Create a Faraday::Response when Faraday::Error appears]
    #
    def response_error(method, path, error)
      body = { Error: error.message }.to_json
      url = URI::HTTP.build({host: URI.parse(base_url).hostname, path: path})

      env = Faraday::Env.new(method, body, url)
      env.response_headers = { "Content-Type" => "application/json" }
      env.status = 499

      Faraday::Response.new(env)
    end

    ##
    # Define the adapter used for make requests
    #
    # :net_http is the default adapter
    # :typhoeus if used for parallel requests
    #
    # Is possible spend another adapter through the options[:adapter], others possible adapters:
    # :net_http_persistent, :patron, :em_synchrony, :em_http, :excon, :rack, :httpclient
    #
    def adapter
      @adapter ||= :typhoeus if options[:parallel]
      @adapter ||= options[:adapter] if valid_adapters.include?(options[:adapter])
      @adapter ||= Faraday.default_adapter
    end

    ##
    # Define the standard headers used for make requests
    #
    def headers
      @headers ||= default_headers.merge(options[:headers] || {})
    end

    ##
    # Define the read timeout
    # Default is 20 seconds
    #
    def timeout
      @timeout ||= options[:timeout] || 20
    end

    ##
    # Define the open timeout
    # Default is 10 seconds
    #
    def open_timeout
      @timeout ||= options[:open_timeout] || 10
    end

    ##
    # Default headers for HTTP requests based on JSON
    #
    def default_headers
      { "Content-Type" => "application/json", "Accept" => "application/json" }
    end

    ##
    # Load base params for each request
    #
    def base_params
      @base_params ||= options[:params] || {}
    end

    ##
    # Default max concurrency for parallel calls
    #
    def max_concurrency
      @max_concurrency ||= options[:max_concurrency] || 10
    end

    ##
    # Define the manager for parallel calls
    #
    def manager
      @manager ||= Typhoeus::Hydra.new(max_concurrency: max_concurrency)
    end

    ##
    # Define a list of valid adapters for requests based on Faraday Adapters
    #
    def valid_adapters
      @adapters ||= [
        :net_http,
        :typhoeus,
        :net_http_persistent,
        :patron,
        :em_synchrony,
        :em_http,
        :excon,
        :rack,
        :httpclient
      ]
    end

end