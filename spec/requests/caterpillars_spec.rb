require 'rails_helper'

RSpec.describe "Caterpillars", type: :request do
  describe "POST /caterpillars/start" do
    before do
      Life.create_and_start
      post "/caterpillars/start", params: { pattern: "1234" }
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns caterpillar info" do
      json = JSON.parse(response.body)
      caterpillar = Caterpillar.last
      expect(json["caterpillar"].keys).to eq caterpillar.info.keys.map(&:to_s)
    end

    it "Occur error if last caterpillar has not finished" do
      post "/caterpillars/start", params: { pattern: "1234" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json["errors"]).to eq ["Last Caterpillar has not finished."]
    end
  end

  describe "POST /caterpillars/finish" do
    before do
      Life.create_and_start
      post "/caterpillars/start", params: { pattern: "1234" }
      post "/caterpillars/finish"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns caterpillar info" do
      json = JSON.parse(response.body)
      caterpillar = Caterpillar.last
      expect(json["caterpillar"].keys).to eq caterpillar.info.keys.map(&:to_s)
    end

    it "caterpillar has finished" do
      caterpillar = Caterpillar.last
      expect(caterpillar.finished?).to be_truthy
    end

    it "Occur error if caterpillar has not started" do
      post "/caterpillars/finish"
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json["errors"]).to eq ["already finished"]
    end
  end
end
