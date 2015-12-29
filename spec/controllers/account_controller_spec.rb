require 'rails_helper'

RSpec.describe AccountController, type: :controller do

  describe "GET #dashboard" do
    before do
      @seller = FactoryGirl.create(:seller)
      sign_in :seller, @seller
    end
    it "returns http success" do
      get :dashboard
      expect(response).to have_http_status(:success)
    end
  end

end
