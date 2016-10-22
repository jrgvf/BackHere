class KpisController < BackHereController
  before_filter :find_kpi, only: [:edit, :update]
  before_filter :load_questions, only: [:new, :create]

  def index
    @kpis = Kpi.asc(:created_at)
  end

  def new
    @kpi = Kpi.new
  end

  def create
    @kpi = Kpi.new(kpi_create_params)
    if @kpi.save
      flash.keep[:info] = "KPI criado com sucesso."
      redirect_to kpis_path
    else
      flash.now[:error] = "Não foi possível criar o KPI."
      render :new
    end
  end

  def edit
  end

  def update
    if @kpi.update_attributes(kpi_update_params)
      flash.keep[:info] = "KPI editado com sucesso."
      redirect_to kpis_path
    else
      flash.now[:error] = "Não foi possível salvar as modificações."
      render :edit
    end
  end

  private

    def find_kpi
      @kpi = Kpi.find(params[:id])
    end

    def load_questions
      question_ids = Kpi.excludes(question_id: nil).only(:question_id).map(&:question_id)
      @questions = Question.where(ready: true, type: :linear_scale).nin(id: question_ids)
    end

    def kpi_create_params
      kpi_base_params.permit(:qualifies, :detracts, :question_id)
    end

    def kpi_update_params
      kpi_base_params.permit(:qualifies, :detracts)
    end

    def kpi_base_params
      params.require(:kpi)
    end

end