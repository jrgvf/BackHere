require "rails_helper"

RSpec.describe HomeMessageMailer, type: :mailer do
  describe "home_message" do
    let(:home_message) { FactoryGirl.build(:home_message) }
    let(:mail) { HomeMessageMailer.home_message(home_message) }

    it "renders the headers" do
      expect(mail.subject).to eq("BackHere - New Home Message by jrgvf@backhere.com.br")
      expect(mail.to).to eq(["jrgvf@cin.ufpe.br"])
      expect(mail.from).to eq(["help@backhere.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Opa, algu=C3=A9m deixou uma mensagem na p=C3=A1gina do BackHere!")
      expect(mail.body.encoded).to match("Mensagem: Testando o email da Home do BackHere!")
    end
  end

end
