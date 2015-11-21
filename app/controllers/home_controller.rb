class HomeController < ApplicationController
  skip_before_filter :set_current_tenant
  def index
  end
end
