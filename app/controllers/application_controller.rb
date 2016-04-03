class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  protect_from_forgery with: :exception

  before_action :prevent_another_sign_in

  devise_group :user_model, contains: [:user, :admin]

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      # format.html { redirect_to main_app.root_url, alert: exception.message }
      format.html { redirect_to :back, alert: exception.message }
    end
  end

  protected

  # def prevent_admin_access_platform
  #   if current_admin && !admin_action?
  #     redirect_to rails_admin_path
  #     flash.keep[:info] = "Você está logado como admin, não é permitido o acesso a plataforma."
  #   end
  # end

  # def admin_action?
  #   (params["controller"] && params["controller"].include?("rails_admin")) || (params["admin"]) || (params["controller"] == "devise/sessions" && params["action"] == "destroy")
  # end

  def prevent_another_sign_in
    if devise_controller? && current_user_model && another_class?
      redirect_to root_path
      flash.keep[:alert] = "Você já está logado."
    end
  end

  def another_class?; !current_user_model.is_a?(resource_class) end

  def resource_class; resource_name.capitalize.to_s.constantize end

end