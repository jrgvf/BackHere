class AccountController < ApplicationController

  def dashboard
  end

  def index_platforms
    @current_platforms = find_current_platforms
    @available_platforms = find_available_platforms
  end

  private

  def find_current_platforms
    Platform.where(account_id: current_account.id)
  end

  def find_available_platforms
    available_platforms = Array.new
    available_platforms << { name: "Magento", url: new_magento_path }
  end
  
end
