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

    it "returns timer info" do
      json = JSON.parse(response.body)
      caterpillar = Caterpillar.last
      expect(json["timer"].keys).to eq caterpillar.timer.info.keys.map(&:to_s)
    end

    it "Occur error if last caterpillar has not finished" do
      post "/caterpillars/start", params: { pattern: "1234" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json["errors"]).to eq ["Timer has already started."]
    end

    it "can restart after stop" do
      post "/caterpillars/stop"
      post "/caterpillars/start"
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(json["caterpillar"]["pattern"]).to eq "1234"
      expect(json["timer"]["isRunning"]).to be_truthy
    end

    it "new caterpillar is created if last caterpillar has finished" do
      post "/caterpillars/finish"
      post "/caterpillars/start", params: { pattern: "1234" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(Caterpillar.count).to eq 2
    end
  end

  describe "POST /caterpillars/stop" do
    before do
      Life.create_and_start
      post "/caterpillars/start", params: { pattern: "1234" }
      post "/caterpillars/stop"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns caterpillar info" do
      json = JSON.parse(response.body)
      caterpillar = Caterpillar.last
      expect(json["caterpillar"].keys).to eq caterpillar.info.keys.map(&:to_s)
    end

    it "returns timer info" do
      json = JSON.parse(response.body)
      caterpillar = Caterpillar.last
      expect(json["timer"].keys).to eq caterpillar.timer.info.keys.map(&:to_s)
    end

    it "caterpillar has stopped" do
      caterpillar = Caterpillar.last
      expect(caterpillar.timer.stopped?).to be_truthy
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

    it "returns timer info" do
      json = JSON.parse(response.body)
      caterpillar = Caterpillar.last
      expect(json["timer"].keys).to eq caterpillar.timer.info.keys.map(&:to_s)
    end

    it "caterpillar has finished" do
      caterpillar = Caterpillar.last
      expect(caterpillar.finished?).to be_truthy
    end

    it "Occur error if caterpillar has not started" do
      post "/caterpillars/finish"
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json["errors"]).to eq ["Timer has already finished."]
    end
  end
end
