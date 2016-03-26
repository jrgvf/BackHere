module Backhere
  module Api
    module CustomerActions

      DEFAULT_ATTRIBUTES = [:remote_id, :first_name, :last_name]

      def create_or_update_customers(results, remote_customers)
        remote_customers.each { |remote_customer| results << create_or_update_customer(remote_customer) }
      end

      def create_or_update_customer(remote_customer)
        new_customer = false

        emails = remote_customer.delete(:emails)
        phones = remote_customer.delete(:phones)        
        customer = Customer.find_by(remote_id: remote_customer[:remote_id])
        customer ||= Customer.find_by(first_name: remote_customer[:first_name], last_name: remote_customer[:last_name], is_guest: true)

        if customer.nil?
          customer = Customer.new(default_attributes(remote_customer))
          new_customer = true
        else
          customer.first_name = remote_customer[:first_name]
          customer.last_name = remote_customer[:last_name]
        end

        customer.fill_dynamic_attributes(others_attributes(remote_customer))
        build_emails(customer, emails)
        build_phones(customer, phones)

        if customer.save
          Backhere::Api::ExecutionResults::Result.new(:success, "Cliente #{customer.name} #{ new_customer ? "importado" : "atualizado" } com sucesso.")
        else
          Backhere::Api::ExecutionResults::Result.new(:failure, customer.errors.full_messages.join('; '))
        end
      end

      def build_emails(customer, emails)
        return if emails.nil? || emails.blank?
        emails.each { |email_address| customer.emails.find_or_initialize_by(address: email_address) }
      end

      def build_phones(customer, phones)
        return if phones.nil? || phones.blank?
        phones.each do phone_infos
          customer.phones.find_or_initialize_by(number: phone_infos[:number], country_code: phone_infos[:country_code], region_code: phone_infos[:region_code])
        end
      end

      def default_attributes(remote_customer)
        remote_customer.select { |key, value| DEFAULT_ATTRIBUTES.include?(key) }
      end

      def others_attributes(remote_customer)
        remote_customer.select { |key, value| !DEFAULT_ATTRIBUTES.include?(key) }
      end

    end
  end
end