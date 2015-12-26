class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  layout 'backhere_seller'

  include CanCan::ControllerAdditions
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  devise_group :user, contains: [:user, :seller, :admin]

  before_action :set_current_tenant, :prevent_another_sign_in, :prevent_admin_access_platform

  # For rescue exceptions of CanCan AccessDenied
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      # format.html { redirect_to main_app.root_url, alert: exception.message }
      format.html { redirect_to :back, alert: exception.message }
    end
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

  def admin_action?
    params["controller"].present? && params["controller"].include?("rails_admin")
  end

  def another_class?
    !current_user.is_a?(resource_class)
  end

  def resource_class
    resource_name.capitalize.to_s.constantize
  end
end
