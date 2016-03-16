class ClientTask < Task

  def self.type
    :client
  end

  def self.visible?
    true
  end

  def self.task_name
    "Importar dados. (Clientes e Pedidos)"
  end

  def task_name
    ClientTask.task_name
  end

  def execute
    self.update_attributes!(started_at: DateTime.now.in_time_zone('Brasilia'), status: :running)
    execution_result = ExecutionResult.new

    platform = Platform.find(platform_id)
    synchronizer = platform.synchronizer

    execution_result.results += synchronizer.create_or_update_local_customers
    # execution_result.results += synchronizer.create_or_update_local_orders

    update_finished_task(execution_result)
  end
end