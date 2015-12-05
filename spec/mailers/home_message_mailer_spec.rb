require "rails_helper"

RSpec.describe HomeMessageMailer, type: :mailer do
  describe "home_message" do
    let(:mail) { HomeMessageMailer.home_message }

    it "renders the headers" do
      expect(mail.subject).to eq("Home message")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
