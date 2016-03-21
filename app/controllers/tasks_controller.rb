class TasksController < ApplicationController
  before_action :find_task, only: [:show]

  def index
    @tasks = Task.where(is_visible: true).order_by(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @platforms = current_account.platforms
    @available_tasks = TaskFactory::TASKS.select { |task| task.visible? }
  end

  def create
    if invalid_params?
      flash.keep[:error] = "Deve ser selecionada qual tarefa deseja executar e ao menos uma plataforma."
      return redirect_to new_task_path
    end

    params[:platform_ids].each do |platform_id|
      platform = Platform.find(platform_id)
      task = TaskFactory.build(type, task_params(platform, platform.worker))

      if task && !task.save
        flash.keep[:error] = "(#{platform.name}) Não foi possível criar a tarefa."
        return redirect_to new_task_path
      end

      TaskTrigger.try_execute(task)
    end

    if params[:platform_ids].count > 1
      flash.keep[:success] = "Tarefas criadas com sucesso."
      redirect_to tasks_path
    else
      flash.keep[:success] = "Tarefa criada com sucesso."
      redirect_to tasks_path
    end
  end

  def show    
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params(platform, worker)
    params.permit(:type, :full_task).merge(platform_id: platform.id.to_s, platform_name: platform.name, executed_by: worker)
  end

  def type
    params[:type].to_sym
  end

  def invalid_params?
    result = params[:platform_ids].blank?
    result = params[:type].blank? unless result
    result
  end

end
