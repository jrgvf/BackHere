class HomeController < ApplicationController
  layout "home"

  skip_before_filter :set_current_tenant
  
  def index
  end
end
