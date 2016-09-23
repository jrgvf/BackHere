class QuestionsController < BackHereController
  before_filter :find_question, only: [:edit, :update, :destroy, :set_ready]

  def index
    @questions = Question.asc(:created_at)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash.keep[:success] = "Pergunta criada com sucesso."
      redirect_to questions_path
    else
      flash.now[:error] = "Não foi possível criar a pergunta."
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update_attributes(question_params)
      flash.keep[:info] = "Pergunta editada com sucesso."
      redirect_to questions_path
    else
      flash.now[:error] = "Não foi possível salvar as modificações."
      render :edit
    end
  end

  def destroy
    respond_to do |format|
      if @question.destroy
        format.js {}
        format.json { render nothing: true, status: 204, location: @question }
      else
        format.json { render json: build_delete_error_message, status: :unprocessable_entity }
      end
    end
  end

  def set_ready
    @question.ready = true
    respond_to do |format|
      if @question.save
        format.js {}
        format.json { render nothing: true, status: 204, location: @question }
      else
        format.json { render json: build_set_ready_error_message, status: :unprocessable_entity }
      end
    end
  end

  private

    def find_question
      @question = Question.find(params[:id] || params[:question_id])
    end

    def question_params
      params.require(:question).permit(:text, :type, :other_option,
          options_attributes: [:id, :_destroy, :text])
    end

    def build_delete_error_message
      message = "Não foi possível excluir a pergunta.<br /><br />"
      message += concat_errors
    end

    def build_set_ready_error_message
      message = "Não foi possível marcar a pergunta como pronta.<br /><br />"
      message += concat_errors
    end

    def concat_errors
      @question.errors.full_messages.join(";<br />")
    end

end