class TasksController < ApplicationController

  def index
  end

  def new
    @platforms = current_account.platforms
    @available_tasks = TaskFactory::TASKS.select { |task| task.visible? }
  end

  def create
    debugger

    @task = TaskFactory.build(task_params[:type], task_params)
  end

  def show    
  end

  private

  def task_params
    params.permit(:platform_ids, :type)
  end

end
