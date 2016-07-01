class CustomerPhoneVerificationTask < Task

  def self.type
    :verification
  end

  def self.generic_type
    :customer_phone_verification
  end

  def self.visible?
    true
  end

  def self.task_name
    "Verificar informações dos clientes (Telefones)"
  end

  def execute
    platform = Platform.find(platform_id)
    started_before ? self.update_attributes!(status: :processing) : self.update_attributes!(started_at: DateTime.now.in_time_zone('Brasilia'), status: :processing)
    execution_result = ExecutionResult.new
    results = Array.new

    customers(platform).each do |customer|
      customer.phones.not_verifieds.each do |phone|
        begin
          response = PhoneChecker.check_phone(phone.full_number)

          if (200..299).include?(response.status)
            result = response.body

            verified = result.has_key?("valid")
            is_valid = result["valid"].to_s == "true"

            phone.update_attributes!({verified: verified, is_valid: is_valid, type: result["type"], location: result["location"], is_mobile: result["is-mobile"]})

            results << Result.new(:success, "Cliente: #{customer.name}, Número: #{phone.full_phone} verificado com sucesso. (#{is_valid ? 'Válido' : 'Inválido'})") if verified
            results << Result.new(:failure, "Cliente: #{customer.name}. Não foi possível verificar o número #{phone.full_phone}.") unless verified
          end
        rescue StandardError => e
          results << Result.new(:error, e.message)
        end
      end
    end

    execution_result.results += results
    update_finished_task(execution_result)
  end

  private

  def customers(platform)
    Customer.where(imported_from: platform.id).with_unchecked_phone
  end
end