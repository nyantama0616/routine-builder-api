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

    it "returns status" do
      expect(response_body['status']).to eq Life.today.status #TODO: status以外も返すかも
    end
  end
end
