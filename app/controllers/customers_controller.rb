class CustomersController < BackHereController
  before_action :find_customer, only: [:show]

  def index
    @customers = Customer.order_by(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show    
  end

  private

    def find_customer
      @customer = Customer.find(params[:id]) or not_found
    end
end
