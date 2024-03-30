require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /home" do
    before do
      Life.create_and_start
      get "/home"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns todayLife" do
      expect(response_body['todayLife']).to eq Life.today.info.as_json
    end
  end
end
