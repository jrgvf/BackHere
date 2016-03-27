class MagentoSynchronizer < Synchronizer

  def translate_customers_to_local(remote_customers)
    translated_customers = Array.new

    remote_customers.each do |remote_customer|
      translated_customer = Hash.new

      translated_customer[:remote_id]   = remote_customer[:customer_id]
      translated_customer[:first_name]  = remote_customer[:firstname].capitalize
      translated_customer[:last_name]   = remote_customer[:lastname].capitalize
      translated_customer[:created_in]  = remote_customer[:created_in]
      translated_customer[:store_id]    = remote_customer[:store_id]
      translated_customer[:group_id]    = remote_customer[:group_id]
      translated_customer[:website_id]  = remote_customer[:website_id]
      translated_customer[:emails]      = [remote_customer[:email]]
      
      translated_customers << translated_customer
    end
    
    translated_customers
  end

  def translate_orders_to_local(remote_orders)
    translated_orders = Array.new

    remote_orders.each do |remote_order|
      translated_order = Hash.new

      translated_order[:remote_id]         = remote_order[:increment_id]
      translated_order[:store_id]          = remote_order[:store_id]
      translated_order[:placed_at]         = remote_order[:created_at]
      translated_order[:total_price]       = remote_order[:grand_total]
      translated_order[:placed_in]         = remote_order[:store_name]
      translated_order[:status]            = extract_status(remote_order)
      translated_order[:shipping]          = extract_shipping_info(remote_order)
      translated_order[:customer]          = extract_customer_info(remote_order)
      translated_order[:shipping_address]  = extract_address(:shipping_address, remote_order)
      translated_order[:billing_address]   = extract_address(:billing_address, remote_order)
      translated_order[:items]             = extract_items(remote_order)
      translated_order[:payment_method]    = remote_order[:payment][:method] unless remote_order[:payment].blank?
      translated_order[:status_history]    = extract_status_history(remote_order)

      translated_orders << translated_order
    end

    translated_orders
  end

  private

  def extract_status(remote_order)
    {
      code:        "#{remote_order[:status]} # #{remote_order[:state]}"
    }
  end

  def extract_shipping_info(remote_order)
    {
      method:      remote_order[:shipping_method],
      description: remote_order[:shipping_description],
      price:       remote_order[:shipping_amount]
    }
  end

  def extract_customer_info(remote_order)
    {
      emails:      [remote_order[:customer_email]],
      group_id:    remote_order[:customer_group_id],
      is_guest:    remote_order[:customer_is_guest],
      document:    remote_order[:customer_taxvat],
      first_name:  remote_order[:firstname],
      last_name:   remote_order[:lastname],
      phones:      [remote_order[:telephone]]
    }
  end

  def extract_address(type, remote_order)
    {
      first_name:  remote_order[:firstname],
      last_name:   remote_order[:lastname],
      street:      remote_order[:street],
      city:        remote_order[:city],
      region:      remote_order[:region],
      post_code:   remote_order[:postcode],
      country:     remote_order[:country_id],
      phone:       remote_order[:telephone]
    }
  end

  def extract_items(remote_order)
    translated_items = Array.new
    Array.wrap(remote_order[:items][:item]).each do |remote_item|
      translated_item = Hash.new

      translated_item[:remote_id]          = remote_item[:product_id]
      translated_item[:type]               = remote_item[:product_type]
      translated_item[:weight]             = remote_item[:weight]
      translated_item[:sku]                = remote_item[:sku]
      translated_item[:name]               = remote_item[:name]
      translated_item[:quantity]           = remote_item[:qty_ordered]
      translated_item[:price]              = remote_item[:price]
      translated_item[:original_price]     = remote_item[:original_price]
      translated_item[:discount]           = remote_item[:discount_amount]
      translated_item[:total_price]        = remote_item[:row_total]
      translated_item[:total_weight]       = remote_item[:row_weight]

      translated_items << translated_item
    end

    translated_items
  end

  def extract_status_history(remote_order)
    translated_trackings = Array.new
    Array.wrap(remote_order[:status_history][:item]).each do |remote_tracking|
      translated_tracking = Hash.new

      translated_tracking[:tracking_date]  = remote_tracking[:created_at]
      translated_tracking[:remote_status]  = remote_tracking[:status]

      translated_trackings << translated_tracking
    end

    translated_trackings
  end

end