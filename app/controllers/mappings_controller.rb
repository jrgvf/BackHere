class MappingsController < BackHereController

  before_action :initialize_variables, only: [:index, :survey_mapping]

  def index
    @survey_mappings = SurveyMapping.asc(:created_at)
  end

  def survey_mapping
    @survey_mapping = SurveyMapping.new(survey_mapping_params)

    respond_to do |format|
      if @survey_mapping.save
        format.js {}
        format.json { render json: @survey_mapping, status: :created, location: @survey_mapping }
      else
        format.json { render json: build_create_error_message, status: :unprocessable_entity }
      end
    end
  end

  def delete_survey_mapping
    @survey_mapping = SurveyMapping.find_by(id: params[:id])

    respond_to do |format|
      if @survey_mapping.destroy
        @survey_mappings = SurveyMapping.asc(:created_at)
        format.js {}
        format.json { render nothing: true, status: 204, location: @survey_mappings }
      else
        format.json { render json: build_delete_error_message, status: :unprocessable_entity }
      end
    end
  end

  private

  def build_create_error_message
    message = "Não foi possível criar o mapeamento.<br /><br />"
    message += concat_errors
  end

  def build_delete_error_message
    message = "Não foi possível excluir o mapeamento.<br /><br />"
    message += concat_errors
  end

  def concat_errors
    @survey_mapping.errors.full_messages.join(";<br />")
  end

  def initialize_variables
    @status_types = StatusType.all
    @surveys = Survey.asc(:created_at)
  end

  def survey_mapping_params
    {
      status_type: status_type,
      survey: survey,
      services: params[:services]
    }
  end

  def status_type
    return if params[:status_type][:code].nil?
    StatusType.find_by(code: params[:status_type][:code].to_sym)
  end

  def survey
    return if params[:survey][:id].nil?
    Survey.find_by(id: params[:survey][:id])
  end

end
