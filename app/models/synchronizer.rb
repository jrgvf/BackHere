class Synchronizer
  include Backhere::Api

  attr_reader :platform, :account

  def initialize(platform)
    @platform = platform
    @account = platform.account
  end

  def create_or_update_local_customers
    begin
      start_date = DateTime.now.in_time_zone(platform.time_zone)
      results = Array.new

      remote_customers = platform.fetch_customers
      translated_customers = translate_customers_to_local(remote_customers)

      create_or_update_customers(results, translated_customers)

      platform.update_attributes!({ last_customer_update: start_date })
    rescue StandardError => e
      debugger
      # TODO: Logger
      results << Result.new(:error, e.message)
    end
    results
  end

  def translate_customers_to_local remote_customers
    raise NotImplementedError
  end

end