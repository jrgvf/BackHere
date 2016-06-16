class TasksController < BackHereController
  before_action :find_task, only: [:show]
  before_action :validate_params, only: [:create]

  def index
    @tasks = Task.where(is_visible: true).desc(:created_at).paginate(page: params[:page], per_page: 10)
  end

  def new
    @platforms = current_account.platforms
    @available_tasks = TaskFactory::TASKS.select { |task| task.visible? }
    @delayer_tasks = DelayerTask.asc(:created_at)

    @intervals  = DelayerTask.intervals
    @days       = DelayerTask.days
    @hours_from = DelayerTask.hours_from
    @hours_to   = DelayerTask.hours_to
  end

  def create_delayer_task
    delayer_task = DelayerTask.new(delayer_task_params)
    return flash.keep[:error] = "Não foi possível criar o agendamento." unless delayer_task.save
    flash.keep[:success] = "Agendamento criado com sucesso."
  end

  def create
    if delayed?
      delayer_task = DelayerTask.find_or_initialize_by(type: type, platform_ids: params["platform_ids"])
      delayer_task.update_attributes(delayer_task_params)

      if delayer_task.save
        flash.keep[:success] = "Agendamento criado com sucesso."
      else
        flash.keep[:error] = "Não foi possível criar o agendamento."
      end

      return redirect_to new_task_path
    else
      params[:platform_ids].each do |platform_id|
        platform = Platform.find(platform_id)
        authorize! :manage, platform

        task = TaskFactory.build(type, task_params(platform))

        if task && !task.save
          flash.keep[:error] = "(#{platform.name}) Não foi possível criar a tarefa."
          return redirect_to new_task_path
        end

        TaskTrigger.try_execute(task)
      end
      flash.keep[:success] = "Tarefa#{'s' if params[:platform_ids].count > 1} criadas com sucesso."
    end

    redirect_to tasks_path
  end

  def show    
  end

  def delete_delayer
    delayer_task = DelayerTask.find(params[:id])

    if delayer_task.destroy
      flash.keep[:success] = "Agendamento removido com sucesso."
    else
      flash.keep[:error] = "Não foi possível remover o agendamento."
    end

    redirect_to new_task_path
  end

  private

  def validate_params
    flash.keep[:alert] = "Deve ser selecionada ao menos uma plataforma." if params[:platform_ids].blank?
    flash.keep[:alert] = "Deve ser selecionado um período de tempo válido." if delayed? && invalid_time_range
    return redirect_to new_task_path if flash.keys.include?("alert")
  end

  def invalid_time_range
    params[:delay][:time_from].to_i >= params[:delay][:time_to].to_i
  end

  def delayed?
    params[:execute].to_s == "delayed"
  end

  def find_task
    @task = Task.find(params[:id]) or not_found
  end

  def task_params(platform)
    params.permit(:type, :full_task).merge(platform_id: platform.id.to_s, platform_name: platform.name)
  end

  def delayer_task_params
    params.require(:delay).permit(:interval, :time_from, :time_to, days:[]).merge({type: type, platform_ids: params["platform_ids"]})
  end

  def type
    params[:type].to_sym
  end

end
