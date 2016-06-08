module SurveyHelper

  def question_title(question)
    question.persisted? ? "Pergunta (#{index_of_question(question)})" : "Nova Pergunta"
  end

  def option_label(option)
    option.persisted? ? "Opção (#{index_of_option(option)})" : "Nova opção"
  end

  def index_of_question(question)
    question.survey.questions.index(question) + 1
  end

  def index_of_option(option)
    option.question.options.index(option) + 1
  end

end