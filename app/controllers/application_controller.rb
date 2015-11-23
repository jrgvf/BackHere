class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  devise_group :person, contains: [:user, :seller, :admin]

  before_action :set_current_tenant

  before_action :prevent_another_sign_in

  # For rescue exceptions of CanCan AccessDenied
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin"
    else
      "application"
    end
  end

  def set_current_tenant
    Mongoid::Multitenancy.current_tenant = nil
    Mongoid::Multitenancy.current_tenant = current_seller.account unless current_seller.nil?
  end

  def prevent_another_sign_in
    if devise_controller? and current_person.present? and another_class?
      redirect_to root_path
      flash.keep[:alert] = "You're signed_in another user."
    end
  end

  def another_class?
    !current_person.is_a?(resource_class)
  end

  def resource_class
    resource_name.capitalize.to_s.constantize
  end

end
