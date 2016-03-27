class MagentoAdapter

  attr_accessor :magento, :api_url, :api_user, :api_key, :session_key, :sync_date, :page, :offset, :date_time_now

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

  def customer_list(full_task, page)
    try_execute_call do
      login unless logged_in?

      initialize_variables(full_task, page)

      response = client.call(:customer_customer_list, message: { sessionId: self.session_key, filters: build_complex_filters(filter_info) })
      { remote_customers: Array.wrap(response.body[:customer_customer_list_response][:store_view][:item]), continue: (end_date < self.date_time_now) }
    end
  end

  def order_list(full_task, page)
    try_execute_call do
      login unless logged_in?

      initialize_variables(full_task, page)

      response = client.call(:sales_order_list, message: { sessionId: self.session_key, filters: build_complex_filters(filter_info) })
      { remote_orders: Array.wrap(response.body[:sales_order_list_response][:result][:item]), continue: (end_date < self.date_time_now) }
    end
  end

  def order_info(increment_id)
    try_execute_call do
      login unless logged_in?
      
      response = client.call(:sales_order_info, message: { sessionId: self.session_key, orderIncrementId: increment_id })
      response.body[:sales_order_info_response][:result]
    end
  end

  private

  def initialize_variables(full_task, page)
    self.sync_date       = complete?(full_task) ? DateTime.parse(self.magento.start_date.to_s) : self.magento.last_customer_update
    self.page            = page
    self.offset          = complete?(full_task) ? 60 : 1
    self.date_time_now   = DateTime.now.in_time_zone(self.magento.time_zone)
    attribute_key = complete?(full_task) ? "created_at" : "updated_at"
    define_pagination_filter(attribute_key)
  end

  def complete?(full_task)
    full_task || self.magento.last_customer_update.blank?
  end

  def filter_info
    @filter_info
  end

  def define_pagination_filter(attribute_key)
    @filter_info = [{ key: attribute_key, operator: 'from', value: start_date.strftime("%Y-%m-%d %H:%M:%S") }, { key: attribute_key, operator: 'to', value: end_date.strftime("%Y-%m-%d %H:%M:%S") }]
  end

  def define_order_info_filter(increment_id)
    @filter_info = [{ key: 'increment_id', operator: 'eq', value: increment_id }]
  end

  def start_date
    self.sync_date + ((self.page - 1) * self.offset).days
  end

  def end_date
    date = self.sync_date + (self.page * self.offset).days
    date = self.date_time_now if date > self.date_time_now
    date #date.strftime("%Y-%m-%d %H:%M:%S %Z")
  end

  ##
  # Build a complex_filters used for a SOAP Call
  #
  # @param [ Array of Hashs { key, operator, value } ] filters_infos - The Array of Hashs of complex filters.
  #
  # @example magento_adapter.build_complex_filters([{ key: 'updated_at', operator: 'gt', value: '1992-01-30' }])
  #
  # @return [ complex filter structure ] - Result of build complex filters.
  def build_complex_filters(filters_infos = [])
    complex_filters = Array.new
    filters_infos.each do |filter_info|
      complex_filters << { key: filter_info[:key], value: { key: filter_info[:operator], value: filter_info[:value] } }
    end
    { 'complex_filter' => [{ 'item' => complex_filters }] }
  end

  def client
    @client ||= Savon.client do |cli|
      cli.wsdl self.api_url
      cli.open_timeout 600
      cli.read_timeout 600
      cli.ssl_verify_mode :none
      # cli.soap_version 2
    end
  end

  def logged_in?; self.session_key.present? end

  def session_expired?(exception)
    hash_exception = exception.to_hash
    hash_exception[:fault] && hash_exception[:fault][:code] && exception.to_hash[:fault][:code][:value].to_s.eql?("5")
  end

  def try_execute_call
    should_retry = true
    begin
      yield
    rescue Savon::SOAPFault => exception
      debugger unless Rails.env.production?
      if session_expired?(exception) && should_retry
        should_retry = false
        self.session_key = nil
        retry
      else
        raise exception
      end
    rescue Savon::Error => exception
      debugger unless Rails.env.production?
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
      debugger unless Rails.env.production?
      # TO DO: Logger!
      raise exception
    end
  end

end