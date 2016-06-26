class CreateSurveyNotificationsTask < Task

  def self.type
    :notification
  end

  def self.generic_type
    :create_survey_notifications
  end

  def self.visible?
    true
  end

  def self.task_name
    "Criar notificações (Pesquisas)"
  end

  def execute
    platform = Platform.find(platform_id)
    started_before ? self.update_attributes!(status: :processing) : self.update_attributes!(started_at: DateTime.now.in_time_zone('Brasilia'), status: :processing)
    execution_result = ExecutionResult.new
    results = Array.new

    mappings.each do |mapping|
      next unless mapping.survey.active?
      
      orders(mapping).each do |order|
        next if order.notifications.where(status_type: mapping.status_type).exists?

        begin
          params = {
            order: order,
            customer: order.customer,
            status_type: mapping.status_type,
            survey: mapping.survey,
            services: mapping.services,
            type: :survey
          }

          notification = SurveyNotification.find_or_initialize_by(params)
          
          if notification.save
            results << Result.new(:success, "Notificação criada com sucesso.")
          else
            results << Result.new(:failure, "Não foi possível criar a notificação. Problemas: #{notification.errors.full_messages}")
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

  def mappings
    SurveyMapping.where(account: account)
  end

  def orders(mapping)
    Order.available_for_notification(account, mapping.statuses.to_a)
  end
end