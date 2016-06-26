class SurveysController < BackHereController
  # before_action :available_surveys, only: [:index]

  before_action :find_survey_by_id, only: [:edit, :update, :destroy]
  before_action :find_survey_by_survey_id, only: [:preview]

  def index
    @surveys = Survey.asc(:created_at)
  end

  def preview
    render layout: 'survey'
  end

  def new
    @survey = Survey.new
    @survey.questions.build
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      flash.keep[:success] = "Pesquisa criada com sucesso."
      redirect_to surveys_path
    else
      flash.now[:error] = "Não foi possível criar a pesquisa."
      render :new
    end
  end

  def edit
  end

  def update
    if @survey.update_attributes(survey_params)
      flash.keep[:info] = "Pesquisa (#{@survey.name.capitalize}) editada com sucesso."
      redirect_to surveys_path
    else
      flash.now[:error] = "Não foi possível salvar as modificações."
      render :edit
    end
  end

  def destroy
    if @survey.destroy
      flash.keep[:success] = "Pesquisa removida com sucesso."
    else
      flash.keep[:error] = "Não foi possível remover a pesquisa."
    end
    redirect_to surveys_path
  end

  private

    # def available_surveys
    #   @available_surveys = Array.new
    #   @available_surveys << { name: "Tradicional", url: new_survey_path }
    # end

    def survey_params
      params.require(:survey).permit(:name, :description, :active,
        questions_attributes: [:id, :_destroy, :text, :type, :other_option,
          options_attributes: [:id, :_destroy, :text]])
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
