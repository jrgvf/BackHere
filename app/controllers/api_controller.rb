class ApiController < ActionController::Base
  include CanCan::ControllerAdditions

  protect_from_forgery with: :null_session

  rescue_from Exception, with: :handle_exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
    end
  end

  protected

    def handle_exception(exception = nil)
      if exception
        logger = Logger.new(STDOUT)
        logger.debug "Exception Message: #{exception.message} \n"
        logger.debug "Exception Class: #{exception.class} \n"
        logger.debug "Exception Backtrace: \n"
        logger.debug exception.backtrace.join("\n")

        respond_to do |format|
          format.json { render json: { exception: {messages: [exception.message]} }, status: :internal_server_error }
        end
      end
    end

end