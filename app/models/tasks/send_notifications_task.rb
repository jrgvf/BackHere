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

      notification.status = :sent if notification.all_messages_sent?
      notification.save!
    end

    execution_result.results += results
    update_finished_task(execution_result)
  end

  private

    def email_notification(notification, results)
      notification.customer.emails.valids.each do |email|
        begin
          message = notification.messages.find_or_initialize_by(identifier: email.address, type: :email)
          next if message.sent?

          NotificationMailer.build_message(notification.id.to_s, email.address).deliver_later
          results << Result.new(:success, "Email enviado com sucesso para #{email.address}.")
          create_message(message, "Sent", "Email enviado.")
        rescue StandardError => e
          results << Result.new(:error, e.message)
          create_message(message, "Erro Sent", e.message)
        end      
      end
    end

    def sms_notification(notification, results)
      notification.customer.phones.valids_mobile.each_with_index do |phone, index|
        begin
          message = notification.messages.find_or_initialize_by(identifier: phone.full_number, type: :sms)
          next if message.sent?
          
          response = NotificationMessenger.deliver_now(notification, phone.full_number, index)

          if (200..299).include?(response.status)
            result = response.body["sendSmsResponse"]
            success = result["statusCode"].to_s == "00"

            if success
              create_message(message, "OK", "Message sent.", "#{notification.token}-#{index}")
              results << Result.new(:success, "SMS enviada com sucesso para #{phone.full_phone}.")
            else
              error_message = "Erro: #{result["statusDescription"]} - #{result["detailDescription"]}"
              create_message(message, "Failure Sent", error_message, "#{notification.token}-#{index}")
              results << Result.new(:failure, "Não foi possível enviar SMS para #{phone.full_phone}. #{error_message}")
            end
          else
            error_message = "Erro: #{response.body.dig("exception", "message")}"
            create_message(message, "Failure Sent", error_message, "#{notification.token}-#{index}")
            results << Result.new(:failure, "Não foi possível enviar SMS para #{phone.full_phone}. #{error_message}")
          end
        rescue StandardError => e
          create_message(message, "Erro Sent", e.message, "#{notification.token}-#{index}")
          results << Result.new(:error, e.message)
        end
      end
    end

    def create_message(message, status, description = "", external_id = nil)
      message.status = status
      message.description = description
      message.external_id = external_id unless external_id.nil?
      message.save!
    end

    def notifications
      Notification.where(account: account).pending
    end

end