class CustomerEmailVerificationTask < Task

  def self.type
    :verification
  end

  def self.generic_type
    :customer_email_verification
  end

  def self.visible?
    true
  end

  def self.task_name
    "Verificar informações (Emails)"
  end

  def execute
    platform = Platform.find(platform_id)
    started_before ? self.update_attributes!(status: :processing) : self.update_attributes!(started_at: DateTime.now.in_time_zone('Brasilia'), status: :processing)
    execution_result = ExecutionResult.new
    results = Array.new

    customers(platform).each do |customer|
      customer.emails.not_verifieds.each do |email|
        begin
          response = EmailChecker.check_email(email.address)

          if (200..299).include?(response.status)
            result = response.body
            
            verified = result["result"] != "unknown"
            is_valid = result["result"] == "valid"

            email.update_attributes!({verified: verified, is_valid: is_valid})

            results << Result.new(:success, "Cliente: #{customer.name}, Email: #{email.address} verificado com sucesso. (#{is_valid ? 'Válido' : 'Inválido'})") if verified
            results << Result.new(:failure, "Cliente: #{customer.name}. Não foi possível verificar o email #{email.address}.") unless verified
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
    Customer.where(imported_from: platform.id).with_unchecked_email
  end
end