class OrdersController < BackHereController

  before_action :find_order, only: [:show]

  def index
    @orders = Order.order_by(placed_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show    
  end

  private

    def find_order
      @order = Order.find(params[:id])
    end

end
