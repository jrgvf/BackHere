class CustomFailure < Devise::FailureApp
    def redirect_url
      if admin_action?
        new_admin_session_url
      else
        new_seller_session_url
      end
    end

    # You need to override respond to eliminate recall
    def respond
      if http_auth?
        http_auth
      else
        redirect
      end
    end

    def admin_action?
      params["controller"].present? && params["controller"].include?("rails_admin") ||
      params["admin"].present?
    end
  end