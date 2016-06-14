class TasksController < BackHereController
  before_action :find_task, only: [:show]

  def index
    @tasks = Task.where(is_visible: true).order_by(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @platforms = current_account.platforms
    @available_tasks = TaskFactory::TASKS.select { |task| task.visible? }
    @intervals = [["5 minutos", :minutes_5], ["15 minutos", :minutes_15], ["30 minutos", :minutes_30]]
    (1..12).each { |n| @intervals << ["#{n} hora#{'s' if n > 1 }", "hours_#{n}".to_sym]}
    @days = [["Segunda-feira", :monday], ["Terça-feira", :tuesday], ["Quarta-feira", :wednesday], ["Quinta-feira", :thursday], ["Sexta-feira", :friday], ["Sábado", :saturday], ["Domingo", :sunday]]
    @hours_from = (0..23).map { |n| "#{n < 10 ? '0' + n.to_s : n}:00"}
    @hours_to = (0..23).map { |n| "#{n < 10 ? '0' + n.to_s : n}:59"}
  end

  def create
    if params[:platform_ids].blank?
      flash.keep[:alert] = "Deve ser selecionada ao menos uma plataforma."
      return redirect_to new_task_path
    end

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
    redirect_to tasks_path
  end

  def show    
  end

  private

  def find_task
    @task = Task.find(params[:id]) or not_found
  end

  def task_params(platform)
    params.permit(:type, :full_task).merge(platform_id: platform.id.to_s, platform_name: platform.name)
  end

  def type
    params[:type].to_sym
  end

end
