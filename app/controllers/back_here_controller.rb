class BackHereController < ApplicationController
  layout 'backhere'
  
  before_action :authenticate_user!
  before_action :set_current_tenant
  
  helper_method :current_account

  protected

  def set_current_tenant
    Tenant.current = current_account
  end

  def current_account
    @current_account ||= current_user.account unless current_user.nil?
  end

end