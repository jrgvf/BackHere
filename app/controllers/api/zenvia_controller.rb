class Api::ZenviaController < ApiController

  before_filter :initialize_by_id, only: :status_update
  before_filter :initialize_by_correlated_id, only: :answer_receive
  before_filter :not_found_error, only: [:status_update, :answer_receive]

  def status_update
    respond_to do |format|
      begin
        Mongoid::Multitenancy.with_tenant(account) do
          @message.status = zenvia_params["statusMessage"]
          @message.status = "Blocked" if @message.status.include?("Blocked")
          @message.status_code = zenvia_params["status"]
          @message.operator = zenvia_params["mobileOperatorName"]
          @message.description = zenvia_params["statusDetailMessage"]

          if @message.save
            format.json { render nothing: true, status: 204 }
          else
            format.json { render json: { exception: {messages: @message.errors.full_messages} }, status: :unprocessable_entity }
          end
        end
      rescue StandardError => e
        format.json { render json: { exception: {messages: [e.message]} }, status: :internal_server_error }
      end
    end
  end

  def answer_receive
    respond_to do |format|
      begin
        Mongoid::Multitenancy.with_tenant(account) do
          @response = @message.responses.find_or_initialize_by(external_id: zenvia_params["id"])
          @response.number = zenvia_params["mobile"]
          @response.short_code = zenvia_params["shortCode"]
          @response.body = zenvia_params["body"]
          @response.received = zenvia_params["received"]

          if @response.save
            format.json { render nothing: true, status: 204 }
          else
            format.json { render json: { exception: {messages: @response.errors.full_messages} }, status: :unprocessable_entity }
          end
        end
      rescue StandardError => e
        format.json { render json: { exception: {messages: [e.message]} }, status: :internal_server_error }
      end
    end
  end

  private

    def initialize_by_id
      @zenvia_params ||= params.require("callbackMtRequest")
      @external_id ||= zenvia_params["id"]
      @message ||= Message.find_by(external_id: @external_id)
    end

    def initialize_by_correlated_id
      @zenvia_params ||= params.require("callbackMoRequest")
      @external_id ||= zenvia_params["correlatedMessageSmsId"]
      @message ||= Message.find_by(external_id: @external_id)
    end

    def account
      @message.account
    end

    def zenvia_params
      @zenvia_params
    end

    def error_status
      ["Blocked", "Error"].any? { |status| zenvia_params["statusMessage"].include?(status) }
    end

    def not_found_error
      if @message.nil?
        respond_to do |format|
          format.json { render json: { exception: {messages: ["Nenhuma mensagem encontrada com o id #{@external_id}."]} }, status: 404 }
        end
      end
    end

end