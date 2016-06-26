class NotificationsController < BackHereController
  layout 'survey'

  skip_before_filter :authenticate_user!, only: [:by_token, :submit_answer]

  before_action :initialize_variables, only: [:by_token, :submit_answer]
  before_action :answered?, only: [:by_token, :submit_answer]

  def by_token
  end

  def submit_answer
    Mongoid::Multitenancy.with_tenant(account) do
      @answer = @survey.answers.build

      customer_answers.each do |index, values|
        answer = answer(values)
        question = question(answer)

        if answer[:option].present?
          answer[:option].each do |option_answer|
            if option_answer == "other_option"
              type = :other_option
              text = answer[type]
              build_response(question, type, text)
            else
              type = :option
              option = question.options.find_by(original_id: option_answer)
              build_response(question, type, option.text, option.original_id)
            end
          end
        else
          type = :text
          text = answer[type]
          build_response(question, type, text)
        end
      end

      if @answer.save
        @notification.update_attributes({status: :answered})
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
      values.permit(:question_id, :text, :other_option, option:[])
    end

    def question(values)
      Question.find(values["question_id"])
    end

    def build_response(question, type, text, option_id = nil)
      @answer.responses.build(question: question, type: type, text: text, option_id: option_id)
    end

end