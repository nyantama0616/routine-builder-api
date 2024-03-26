require 'rails_helper'

RSpec.describe "Waters", type: :request do
  describe "GET /waters" do
    before do
      Life.create_and_start
      get "/waters"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns water amount" do
      life = Life.today
      amount = JSON.parse(response.body)["amount"]
      expect(amount).to eq life.water_info.stringify_keys
    end
  end

  describe "POST /waters/drink_water" do
    before do
      Life.create_and_start
      post "/waters/drink_water", params: { xml: 200 }
    end
    
    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns water amount" do
      life = Life.today
      amount = JSON.parse(response.body)["amount"]
      expect(amount).to eq life.water_info.stringify_keys
    end

    it "increases water amount" do
      life = Life.today
      expect(life.water).to eq 200
    end
  end
end
