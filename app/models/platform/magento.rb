class Magento < Platform

  field :url,                  type: String
  field :api_user,             type: String
  field :api_key,              type: String
  field :api_url,              type: String
  field :version,              type: String
  field :specific_version,     type: String

  validates_presence_of :url, :api_user, :api_key, :api_url, :version
  validates_inclusion_of :version, in: :version_enum

  def platform_name
    "Magento"  
  end

  def sidekiq_queue
    :magento
  end

  def synchronizer
    MagentoSynchronizer.new(self)
  end

  def version_enum
    ["1.X", "2.X"]
  end

  def magento_adapter
    @magento_adapter ||= MagentoAdapter.new(self)
  end

  def get_specific_version
    response = magento_adapter.magento_info
    "#{response[:magento_version]} - #{response[:magento_edition]}"
  end

  def fetch_customers(full_task, page)
    magento_adapter.customer_list(full_task, page)
  end

  def fetch_orders(full_task, page)
    order_list = magento_adapter.order_list(full_task, page)

    increments_id = order_list[:remote_orders].map{ |remote_order| remote_order[:increment_id] }
    remote_orders = increments_id.map{ |increment_id| magento_adapter.order_info(increment_id) }

    remote_orders = merge_order_info(order_list[:remote_orders], remote_orders)
    
    { remote_orders: remote_orders, continue: order_list[:continue] }
  end

  private

  def merge_order_info(result_order_list, result_order_info)
    merged_orders = Array.new
    (0...(result_order_list.count)).each do |iterator|
      merged_orders << result_order_list[iterator].merge(result_order_info[iterator])
    end
    merged_orders
  end

end
