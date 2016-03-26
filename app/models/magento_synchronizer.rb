class MagentoSynchronizer < Synchronizer

  def translate_customers_to_local(remote_customers)
    customers = Array.new

    remote_customers.each do |remote_customer|
      customer = Hash.new

      customer[:remote_id]    = remote_customer[:customer_id]
      customer[:first_name]   = remote_customer[:firstname].capitalize
      customer[:last_name]    = remote_customer[:lastname].capitalize
      customer[:created_in]   = remote_customer[:created_in]
      customer[:store_id]     = remote_customer[:store_id]
      customer[:group_id]     = remote_customer[:group_id]
      customer[:website_id]   = remote_customer[:website_id]
      customer[:emails]       = [remote_customer[:email]]
      
      customers << customer
    end
    
    customers
  end

end