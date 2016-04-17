class StatusesController < BackHereController

  before_action :find_status,         only: [:update]
  before_action :find_status_types,   only: [:index, :create]
  before_action :new_status,          only: [:index]

  def index
    @statuses = Status.order_by(status_type: :asc)
  end

  def update
    @old_label = @status.label
    respond_to do |format|
      if @status.update_attributes(status_params)
        format.json { render json: @status }
      else
        format.json { render json: build_update_error_message, status: :unprocessable_entity }
      end
    end
  end

  def create
    @status = Status.new(status_params)
    respond_to do |format|
      if @status.save
        format.js {}
        format.json { render json: @status, status: :created, location: @status }
      else
        format.json { render json: build_create_error_message, status: :unprocessable_entity }
      end
    end
  end

  private

    def find_status
      @status = Status.find(params[:id]) or not_found
    end

    def find_status_types
      @status_types = StatusType.all
    end

    def new_status
      @new_status = Status.new
    end

    def status_params
      params.require(:status).permit(:code, :label).merge(status_type)
    end

    def status_type
      return {} if params[:status][:status_type].nil?
      status_type = StatusType.find_by(code: params[:status][:status_type].to_sym)
      { status_type: status_type }
    end

    def build_update_error_message
      message = "Não foi possível atualizar o status: #{@old_label}.<br /><br />"
      message += concat_errors
    end

    def build_create_error_message
      message = "Não foi possível criar o status.<br /><br />"
      message += concat_errors
    end

    def concat_errors
      @status.errors.full_messages.join(";<br />")
    end
end
