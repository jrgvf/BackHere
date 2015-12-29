class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  layout 'backhere_seller'
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_current_tenant, :prevent_another_sign_in, :prevent_admin_access_platform

  helper_method :current_account

  devise_group :user, contains: [:user, :seller, :admin]

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      # format.html { redirect_to main_app.root_url, alert: exception.message }
      format.html { redirect_to :back, alert: exception.message }
    end
  end

  def current_account
    @current_account = current_user.account unless current_user.nil?
  end

  protected

  def set_current_tenant
    Mongoid::Multitenancy.current_tenant = nil
    Mongoid::Multitenancy.current_tenant = current_seller.account unless current_seller.nil?
  end

  def prevent_another_sign_in
    if devise_controller? and current_user.present? and another_class?
      redirect_to root_path
      flash.keep[:alert] = "Você já está logado."
    end
  end

  def prevent_admin_access_platform
    if current_user.present? && current_user.is_admin? && !admin_action? && !devise_controller?
      redirect_to rails_admin_path
      flash.keep[:info] = "Você está logado como admin, não é permitido o acesso a plataforma."
    end
  end

  def admin_action?; params["controller"].present? && params["controller"].include?("rails_admin") end

  def another_class?; !current_user.is_a?(resource_class) end

  def resource_class; resource_name.capitalize.to_s.constantize end

end