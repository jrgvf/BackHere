class QuestionsController < BackHereController
  before_filter :find_question, only: [:edit, :update, :destroy, :set_ready]
  before_filter :find_tags, only: [:new, :create, :edit, :update]
  before_filter :check_ready, only: [:edit, :destroy, :set_ready]

  def index
    @questions = Question.asc(:created_at)
  end

  def new
    @question = Question.new
    respond_to do |format|
      format.js { render template: 'surveys/new_question.js.erb' }
      format.json { render nothing: true, status: 204, location: @question }
      format.html { render :new }
    end
  end

  def create
    respond_to do |format|
      @question = Question.new(question_params)
      add_tags
      if @question.save
        format.js { render template: 'surveys/create_question_success.js.erb' }
        format.json { render json: @question, status: 201, location: @question }
        format.html do
          flash.keep[:success] = "Pergunta criada com sucesso."
          redirect_to questions_path
        end
      else
        format.js { render template: 'surveys/create_question_error.js.erb' }
        format.json { render json: @question.errors.full_messages, status: :unprocessable_entity, location: @question }
        format.html do
          flash.now[:error] = "Não foi possível criar a pergunta."
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    add_tags
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

  def filter
    respond_to do |format|
      @questions = apply_filters([:_id, :text])
      format.js {}
      format.json { render json: @questions }
    end
  end

  private

    def check_ready
      if @question.ready
        flash.keep[:error] = 'Não é permitido alterar uma questão pronta.'
        return redirect_to questions_path
      end
    end

    def apply_filters(only_fields = [])
      criteria = Question.where(account_id: current_account.id, ready: true).desc(:created_at)
      criteria = criteria.nin(id: params[:question_ids])
      criteria = criteria.elem_match(tags: {:name.in => tags}) unless tags.empty?
      criteria = criteria.only(only_fields) unless only_fields
      criteria.to_a
    end

    def tags
      @tags_params ||= Array.wrap(params[:tags]).reject(&:blank?)
    end

    def add_tags
      @question.tags = tags.map { |tag| @question.tags.find_or_initialize_by({name: tag}) }
    end

    def find_question
      @question = Question.find(params[:id] || params[:question_id])
    end

    def find_tags
      @tags = Tag.asc(:name)
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