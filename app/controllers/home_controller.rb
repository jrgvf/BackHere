class HomeController < ApplicationController
  layout "home"

  skip_before_filter :set_current_tenant

  before_action :sanitize_params, only: :create_home_message
  
  def index
  end

  def create_home_message
    @home_message = HomeMessage.new(home_message_params)
    respond_to do |format|
      if @home_message.save
        format.json { render json: @home_message }
      else
        format.json { render json: errors_response(@home_message.errors.full_messages), status: :unprocessable_entity }
      end
    end
  end

  private

  def errors_response errors_messages
    response = String.new
    errors_messages.each { |msg| response += msg + " <br />"}
    response
  end

  def sanitize_params
    params.require(:home_message).each { |param, value| value.strip! }
    params.require(:home_message)[:fone].gsub!(/[\W,_]/,'')
    params.require(:home_message)[:name].downcase!
    params.require(:home_message)[:email].downcase!
  end

  def home_message_params
    params.require(:home_message).permit(:name, :email, :fone, :message)
  end
end
