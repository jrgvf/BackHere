module Backhere
  module Api
    module OrderActions

      def create_or_update_orders(results, remote_orders)
        remote_orders.each { |remote_order| results << create_or_update_order(remote_order) }
      end

      def create_or_update_order(remote_order)
        new_order = false

        remote_status   = remote_order.delete(:status)
        remote_customer = remote_order.delete(:customer)
        order_status    = Backhere::Api::StatusActions.find_or_create_status(remote_status)[:status]
        order_customer  = Backhere::Api::CustomerActions.find_or_create_customer(remote_customer)[:customer]

        order = Order.find_by(remote_id: remote_order[:remote_id])
        
        if order.present?
          order.assign_attributes(order_params(remote_order, order_status, order_customer))
        else
          new_order = true
          order = Order.new(order_params(remote_order, order_status, order_customer))
        end
        
        if order.save
          Backhere::Api::ExecutionResults::Result.new(:success, "Pedido #{order.remote_id} #{ new_order ? "importado" : "atualizado" } com sucesso.")
        else
          Backhere::Api::ExecutionResults::Result.new(:failure, order.errors.full_messages.join('; '))
        end
      end

      def order_params(remote_order, status, customer)
        remote_order.merge(status: status, customer: customer)
      end

    end
  end
end