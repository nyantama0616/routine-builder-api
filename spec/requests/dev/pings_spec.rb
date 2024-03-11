require 'rails_helper'

RSpec.describe "Dev::Pings", type: :request do
  describe "GET /dev/ping" do
    before do
      get '/dev/ping'
    end

    it "returns 200 OK" do  
      expect(response).to have_http_status(200)
    end

    it "returns { message: 'pong' }" do
      json = JSON.parse(response.body)
      expect(json).to eq({ "message" => "pong" })
    end
  end
end
