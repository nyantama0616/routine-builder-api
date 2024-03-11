require 'rails_helper'

RSpec.describe "Dev::Pings", type: :request do
  describe "GET /dev/ping" do
    before do
      get '/dev/ping'
    end

    it "returns 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns { message: 'pong', authorized: false }" do
      json = JSON.parse(response.body)
      expect(json).to eq({ "message" => "pong", "authorized" => false })
    end

    it "headerにdata-access-keyを含めると、authorizedがtrueになる" do
      access_key = ENV["ACCESS_KEY"]
      get '/dev/ping', headers: { 'data-access-key' => access_key }
      json = JSON.parse(response.body)
      expect(json).to eq({ "message" => "pong", "authorized" => true })
    end
  end
end
