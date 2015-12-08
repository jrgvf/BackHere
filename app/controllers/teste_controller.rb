class TesteController < ApplicationController
  before_action :authenticate_seller!

  # skip_before_filter :set_current_tenant
 
  def index
  end
end
