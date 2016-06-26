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
      # sms_notification(notification, results) if notification.services.include?(:sms)
    end

    execution_result.results += results
    update_finished_task(execution_result)
  end

  private

    def email_notification(notification, results)
      begin
        notification.customer.emails.valids.each do |email|
          NotificationMailer.build_message(notification.id.to_s, email.address).deliver_later
          results << Result.new(:success, "Notificação enviada com sucesso para #{email.address}.")
        end
        notification.update_attributes!({ status: :sent })
      rescue StandardError => e
        notification.update_attributes!({ status: :error })
        results << Result.new(:error, e.message)
      end      
    end

    def notifications
      Notification.where(account: account).pending
    end

end