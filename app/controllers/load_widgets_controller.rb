class LoadWidgetsController < BackHereController

  def orders
    begin
      respond_to do |format|
        @orders = Order.where(account: current_account)
        format.js {}
      end
    rescue
      format.json { render nothing: true, status: :unprocessable_entity }
    end
  end

  def customers
    begin
      respond_to do |format|
        @customers = Customer.where(account: current_account)
        format.js {}
      end
    rescue
      format.json { render nothing: true, status: :unprocessable_entity }
    end
  end

  def messages
    begin
      respond_to do |format|
        @messages = Message.where(account: current_account)
        format.js {}
      end
    rescue
      format.json { render nothing: true, status: :unprocessable_entity }
    end
  end

  def surveys
    begin
      respond_to do |format|
        @surveys = Survey.where(account: current_account, active: true)
        format.js {}
      end
    rescue
      format.json { render nothing: true, status: :unprocessable_entity }
    end
  end

  def answers
    begin
      respond_to do |format|
        @answers = SurveyAnswer.where(account: current_account)
        format.js {}
      end
    rescue
      format.json { render nothing: true, status: :unprocessable_entity }
    end
  end

  def lastet_orders
    begin
      respond_to do |format|
        @lastet_orders = Order.where(account: current_account).asc(:placed_at).limit(10)
        format.js {}
      end
    rescue
      format.json { render nothing: true, status: :unprocessable_entity }
    end
  end

end
