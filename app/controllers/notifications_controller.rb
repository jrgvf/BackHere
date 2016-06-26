class NotificationsController < BackHereController

  def by_token
    @notification = Notification.find_by(token: params[:token])
  end

end