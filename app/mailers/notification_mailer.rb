class NotificationMailer < ApplicationMailer
  layout 'backhere/notification'

  def build_message(account_id, token, email_address)
    @account = Account.find_by(id: account_id)
    @token = token

    mail to: email_address, subject: "[BackHere] - #{@account.name} gostaria de saber sua opinião"
  end
end
