class StatusController < BackHereController
  before_action :find_status, only: [:update]

  def index
    @status = Status.order_by(status_type: :asc)
    @status_types = StatusType.all
  end

  def update
    @old_label = @status.label
    respond_to do |format|
      if @status.update_attributes(status_params)
        format.json { render json: @status }
      else
        format.json { render json: build_error_message, status: :unprocessable_entity }
      end
    end
  end

  private

    def build_error_message
      message = "Não foi possível atualizar o status: #{@old_label}.<br />"
      message += @status.errors.full_messages.join(";<br />")
    end

    def find_status
      @status = Status.find(params[:id])
    end

    def status_params
      params.require(:status).permit(:code, :label).merge(status_type)
    end

    def status_type
      status_type = StatusType.find_by(code: params[:status][:status_type].to_sym)
      { status_type: status_type }
    end
end
