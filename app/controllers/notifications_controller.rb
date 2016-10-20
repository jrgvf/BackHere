class NotificationsController < BackHereController
  layout :layout_by_action

  skip_before_filter :authenticate_user!, only: [:by_token, :submit_answer]

  before_action :initialize_variables, only: [:by_token, :submit_answer]
  before_action :answered?, only: [:by_token, :submit_answer]

  def index
    @notifications = Notification.order_by(created_at: :desc).paginate(page: params[:page], per_page: 10)
    render layout: 'backhere'
  end

  def by_token
  end

  def submit_answer
    Tenant.with_tenant(account) do
      @answer = @survey.answers.build
      @answer.customer = @notification.customer

      customer_answers.each do |index, values|
        answer = answer(values)
        question = question(answer)

        if answer[:option].present?
          answer[:option].each do |option_answer|
            if option_answer == "other_option"
              type = :other_option
              response = answer[type]
              build_response(question, type, response)
            else
              type = :option
              option = question.options.find_by(original_id: option_answer)
              build_response(question, type, option.text, option.original_id)
            end
          end
        else
          type = :linear_scale if answer[:linear_scale].present?
          type ||= :text
          response = answer[type]
          build_response(question, type, response)
        end
      end

      if @answer.save
        @notification.update_attributes({status: :answered, answer: @answer})
        render :success
      else
        flash.now[:error] = "Não foi possível salvar as respostas, verifique se não deixou algo em branco."
        render :by_token
      end
    end
  end

  private

    def initialize_variables
      @notification = Notification.find_by(token: params[:token])
      @survey = @notification.survey
    end

    def answered?
      return render :answered if @notification.answered?
    end

    def account
      @survey.account
    end

    def customer_answers
      params.require(:answers)
    end

    def answer(values)
      values.permit(:question_id, :text, :other_option, :linear_scale, option:[])
    end

    def question(values)
      Question.find(values["question_id"])
    end

    def build_response(question, type, response, option_id = nil)
      response_params = { question_id: question.id, response: response }
      response_params.merge!({option_id: option_id}) unless option_id.nil?
      QuestionResponseFactory.build(@answer, type, response_params)
    end

    def layout_by_action
      ["index"].include?(params["action"]) ? "backhere" : "survey"
    end

end