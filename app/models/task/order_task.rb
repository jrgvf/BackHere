class OrderTask < Task

  def self.type
    :data_import
  end

  def self.generic_type
    :import_orders
  end

  def self.visible?
    true
  end

  def self.task_name
    "Importar Pedidos"
  end

  def execute
    platform = Platform.find(platform_id)
    started_before ? self.update_attributes!(status: :processing) : self.update_attributes!(started_at: DateTime.now.in_time_zone(platform.time_zone), status: :processing)
    execution_result = ExecutionResult.new
    synchronizer = platform.synchronizer

    options = { page: self.iteration_index, continue: self.continue}
    execution_result.results += synchronizer.create_or_update_local_orders(full_task, options)

    if options[:continue]
      self.update_attributes!(status: :paused, iteration_index: (options[:page] + 1), continue: options[:continue])
      update_messages(execution_result)
    else
      update_finished_task(execution_result, "last_order_update")
    end
  end
end