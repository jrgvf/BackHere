class AnswersController < BackHereController

  before_filter :find_answer, only: [:show]

  def show
  end

  private

    def find_answer
      @answer = SurveyAnswer.find(params[:id])
    end

end