class MagentoAdapter

  attr_accessor :magento, :api_url, :api_user, :api_key, :session_key

  def initialize(magento)
    @magento    = magento
    @api_url    = magento.api_url
    @api_user   = magento.api_user
    @api_key    = magento.api_key
    @session_key = nil
  end

  def login
    response = client.call(:login, message: { username: self.api_user, apiKey: self.api_key } )
    self.session_key = response.body[:login_response][:login_return]
  end

  def magento_info
    try_execute_call do
      login unless logged_in?
      response = client.call(:magento_info, message: { sessionId: self.session_key })
      response.body[:magento_info_response][:info]
    end
  end

  def customer_list
    try_execute_call do
      login unless logged_in?
      response = client.call(:customer_customer_list, message: { sessionId: self.session_key })
      response.body[:customer_customer_list_response][:store_view][:item]
    end
  end

  private

  def client
    @client ||= Savon.client do |cli|
      cli.wsdl self.api_url
      cli.open_timeout 600
      cli.read_timeout 600
      cli.ssl_verify_mode :none
      cli.soap_version 2
    end
  end

  def logged_in?; self.session_key.present? end

  def session_expired?(exception); exception.to_hash[:fault][:code][:value].to_s.eql?("5") end

  def try_execute_call
    should_retry = true
    begin
      yield
    rescue Savon::SOAPFault => exception
      debugger
      if session_expired?(exception) && should_retry
        should_retry = false
        self.session_key = nil
        retry
      else
        raise exception
      end
    rescue Savon::Error => exception
      debugger
      if should_retry
        should_retry = false
        # TO DO: Logger!
        sleep(10)
        retry
      else
        # TO DO: Logger!
        raise exception
      end
    rescue Exception => exception
      debugger
      # TO DO: Logger!
      raise exception
    end
  end

end
