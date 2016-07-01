class SendNotificationsTask < Task

  def self.type
    :notification
  end

  def self.generic_type
    :send_notifications
  end

  def self.visible?
    true
  end

  def self.task_name
    "Envio de notificações"
  end

  def execute
    platform = Platform.find(platform_id)
    started_before ? self.update_attributes!(status: :processing) : self.update_attributes!(started_at: DateTime.now.in_time_zone('Brasilia'), status: :processing)
    execution_result = ExecutionResult.new
    results = Array.new

    notifications.each do |notification|
      email_notification(notification, results) if notification.of_email?
      sms_notification(notification, results)   if notification.of_sms?

      notification.update_attributes!({ status: :sent })
    end

    execution_result.results += results
    update_finished_task(execution_result)
  end

  private

    def email_notification(notification, results)
      begin
        notification.customer.emails.valids.each do |email|
          NotificationMailer.build_message(notification.id.to_s, email.address).deliver_later
          results << Result.new(:success, "Email enviado com sucesso para #{email.address}.")
        end
      rescue StandardError => e
        results << Result.new(:error, e.message)
      end      
    end

    def sms_notification(notification, results)
      notification.customer.phones.valids_mobile.each_with_index do |phone, index|
        begin
          number = phone.full_number
          messenger = NotificationMessenger.build_messenger(notification, number, index)
          response  = messenger.deliver

          if (200..299).include?(response.status)
            result = response.body["sendSmsResponse"]
            success = result["statusCode"].to_s == "00"

            if success
              results << Result.new(:success, "SMS enviada com sucesso para #{phone.full_phone}.")
            else
              results << Result.new(:failure, "Não foi possível enviar SMS para #{phone.full_phone}. Erro: #{result["statusDescription"]} - #{result["detailDescription"]}")
            end
          else
            results << Result.new(:failure, "Não foi possível enviar SMS para #{phone.full_phone}. Erro: #{result.dig("exception", "message")}")
          end
        rescue StandardError => e
          results << Result.new(:error, e.message)
        end
      end
    end

    def notifications
      Notification.where(account: account).pending
    end

end