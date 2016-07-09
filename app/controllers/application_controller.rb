class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  protect_from_forgery with: :exception

  before_action :clear_current_tenant
  before_action :prevent_another_sign_in

  devise_group :user_model, contains: [:user, :admin]

  rescue_from Exception, with: :handle_exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      # format.html { redirect_to main_app.root_url, alert: exception.message }
      format.html { redirect_to :back, alert: exception.message }
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def clear_current_tenant
    Mongoid::Multitenancy.current_tenant = nil
  end

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

    expire_in(0)

    if devise_controller? && current_user_model && another_class?
      redirect_to root_path
      flash.keep[:alert] = "Você já está logado."
    end
  end

  def another_class?; !current_user_model.is_a?(resource_class) end

  def resource_class; resource_name.capitalize.to_s.constantize end


  def handle_exception(exception = nil)
    if exception
      logger = Logger.new(STDOUT)
      logger.debug "Exception Message: #{exception.message} \n"
      logger.debug "Exception Class: #{exception.class} \n"
      logger.debug "Exception Backtrace: \n"
      logger.debug exception.backtrace.join("\n")
      
      if [ActionController::RoutingError, ActionController::UnknownController].include?(exception.class)
        return render_404
      else
        raise exception unless Rails.env.production?
        return render_500
      end
    end
  end

  def render_404
    respond_to do |format|
      if current_user.present?
        format.html { render file: "#{Rails.root}/public/loged_404.html.erb", layout: 'layouts/backhere', status: 404 }
      else
        format.html { render file: "#{Rails.root}/public/404.html", layout: false, status: 404 }
      end
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500
    respond_to do |format|
      if current_user.present?
        format.html { render file: "#{Rails.root}/public/loged_500.html.erb", layout: 'layouts/backhere', status: 500 }
      else
        format.html { render file: "#{Rails.root}/public/500.html", layout: false, status: 500 }
      end
      format.all { render nothing: true, status: 500}
    end
  end

end