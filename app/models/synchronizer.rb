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
      # TODO: Logger
      results << Result.new(:error, e.message)
    end
    options[:continue] = fetch_result[:continue]
    results
  end

  def translate_customers_to_local remote_customers
    raise NotImplementedError
  end

end