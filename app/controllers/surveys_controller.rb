class SurveysController < BackHereController
  # before_action :available_surveys, only: [:index]

  before_action :find_survey_by_id, only: [:edit, :update, :destroy]
  before_action :find_survey_by_survey_id, only: [:preview]
  before_action :check_question_ids, only: [:update, :create]

  def index
    @surveys = Survey.asc(:created_at)
  end

  def preview
    render layout: 'survey'
  end

  def new
    @survey = Survey.new
    @questions = Question.desc(:created_at)
    @tags = Tag.asc(:created_at)
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      flash.keep[:success] = "Pesquisa criada com sucesso."
      redirect_to surveys_path
    else
      @questions = Question.nin(id: @survey.question_ids).desc(:created_at)
      @tags = Tag.asc(:created_at)

      flash.now[:error] = "Não foi possível criar a pesquisa."
      render :new
    end
  end

  def edit
    @questions = Question.nin(id: @survey.question_ids).desc(:created_at)
    @tags = Tag.asc(:created_at)

    if SurveyMapping.where(survey_id: @survey.id).exists?
      flash.keep[:alert] = "Não é possível editar uma pesquisa mapeada."
      redirect_to surveys_path
    elsif Notification.where(survey_id: @survey.id).exists?
      flash.keep[:alert] = "Não é possível editar uma pesquisa que já foi notificada."
      redirect_to surveys_path
    end
  end

  def update
    if @survey.update_attributes(survey_params)
      flash.keep[:info] = "Pesquisa (#{@survey.name.capitalize}) editada com sucesso."
      redirect_to surveys_path
    else
      @questions = Question.nin(id: @survey.question_ids).desc(:created_at)
      @tags = Tag.asc(:created_at)
      
      flash.now[:error] = "Não foi possível salvar as modificações."
      render :edit
    end
  end

  def destroy
    if SurveyMapping.where(survey_id: @survey.id).exists?
      flash.keep[:alert] = "Não é possível excluir uma pesquisa mapeada."
      return redirect_to surveys_path
    elsif Notification.where(survey_id: @survey.id).exists?
      flash.keep[:alert] = "Não é possível excluir uma pesquisa que já foi notificada."
      return redirect_to surveys_path
    end

    if @survey.destroy
      flash.keep[:success] = "Pesquisa removida com sucesso."
    else
      flash.keep[:error] = "Não foi possível remover a pesquisa."
    end
    redirect_to surveys_path
  end

  private

    def check_question_ids
      if survey_params[:question_ids].blank?
        flash.keep[:error] = 'É necessário selecionar ao menos uma pergunta.'
        return redirect_to :back
      end
    end

    # def available_surveys
    #   @available_surveys = Array.new
    #   @available_surveys << { name: "Tradicional", url: new_survey_path }
    # end

    def survey_params
      @survey_params ||= params.require(:survey).permit(:name, :description, :active).tap do |whitelisted|
        whitelisted[:question_ids] = params[:survey][:question_ids]
      end
    end

    def answer(values)
      values.permit(:question_id, :text, :other_option, option:[])
    end

    def question(values)
      Question.find(values["question_id"])
    end

    def answers
      params.require(:answers)
    end

    def find_survey_by_id
      @survey = Survey.find(params[:id])
    end

    def find_survey_by_survey_id
      @survey = Survey.find(params[:survey_id])
    end

end
