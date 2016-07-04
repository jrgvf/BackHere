class OrdersController < BackHereController

  before_action :find_order, only: [:show, :update]

  def index
    @orders = Order.desc(:placed_at).paginate(page: params[:page], per_page: 10)
  end

  def show    
  end

  def update
    respond_to do |format|
      begin
        if @order.update_attributes(order_params)
          format.json { render nothing: true, status: 204 }
        else
          format.json { render json: @order.errors.full_messages, status: :unprocessable_entity }
        end
      rescue StandardError => e
        format.json { render json: e.message, status: :internal_server_error }
      end
    end
  end

  private

    def find_order
      @order = Order.find(params[:id]) or not_found
    end

    def order_params
      params.require(:order).permit(:available_for_notification)
    end

end
