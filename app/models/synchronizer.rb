class Synchronizer
  include Backhere::Api

  attr_reader :platform, :account

  def initialize(platform)
    @platform = platform
    @account = platform.account
  end

  def create_or_update_local_customers(full_task, options)
    begin
      start_date = DateTime.now.in_time_zone(platform.time_zone)
      results = Array.new
      page = options[:page]

      fetch_result = platform.fetch_customers(full_task, page)
      translated_customers = translate_customers_to_local(fetch_result[:remote_customers])

      create_or_update_customers(results, translated_customers)
    rescue StandardError => e
      debugger unless Rails.env.production?
      # TODO: Logger
      results << Result.new(:error, e.message)
    end
    options[:continue] = fetch_result[:continue]
    results
  end

  def create_or_update_local_orders(full_task, options)
    begin
      start_date = DateTime.now.in_time_zone(platform.time_zone)
      results = Array.new
      page = options[:page]

      fetch_result = platform.fetch_orders(full_task, page)
      translated_orders = translate_orders_to_local(fetch_result[:remote_orders])

      create_or_update_orders(results, translated_orders)
      options[:continue] = fetch_result[:continue]
      
    rescue StandardError => e
      debugger unless Rails.env.production?
      # TODO: Logger
      options[:continue] = false
      results << Result.new(:error, e.message)
    end
    results
  end

  def translate_customers_to_local remote_customers
    raise NotImplementedError
  end

end