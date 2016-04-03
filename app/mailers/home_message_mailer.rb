class HomeMessageMailer < ApplicationMailer
  layout 'backhere/mailer'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.home_message_mailer.home_message.subject
  #
  def home_message(home_message)
    @home_message = home_message

    mail to: ENV['BACKHERE_MAIL'], subject: "BackHere - New Home Message by #{home_message.email}"
  end
end
