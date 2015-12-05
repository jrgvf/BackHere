# Preview all emails at http://localhost:3000/rails/mailers/home_message_mailer
class HomeMessageMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/home_message_mailer/home_message
  def home_message
    home_message = FactoryGirl.build(:home_message)
    HomeMessageMailer.home_message(home_message)
  end

end
