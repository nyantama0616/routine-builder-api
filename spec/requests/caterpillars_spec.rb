require 'rails_helper'

RSpec.shared_examples "returns caterpillars basic response" do
  it "returns 200" do
    expect(response).to have_http_status(200)
  end

  it "returns caterpillar info" do
    caterpillar = Caterpillar.last
    expect(response_body["caterpillar"]).to eq caterpillar.info.as_json
  end

  it_behaves_like "timerable request", Caterpillar
end

RSpec.describe "Caterpillars", type: :request do
  describe "GET /caterpillars" do
    before do
      Life.create_and_start
      @caterpillar = Caterpillar.create_and_start!("1234")
      get "/caterpillars"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns caterpillar in progress" do
      in_progress = response_body["inProgress"]
      expect(in_progress["caterpillar"]["pattern"]).to eq @caterpillar.pattern
      expect(in_progress["timer"]["isRunning"]).to be true

      @caterpillar.finish
      get "/caterpillars"
      in_progress = response_body["inProgress"]
      expect(in_progress).to be_nil
    end

    it "returns all patterns" do
      expect(response_body["patterns"]).to eq Caterpillar.all_patterns
    end
  end

  describe "POST /caterpillars/start" do
    before do
      Life.create_and_start
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
    end

    it_behaves_like "returns caterpillars basic response"

    it "Occur error if last caterpillar has not finished" do
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["Timer has already started."]
    end

    it "can restart after stop" do
      post "/caterpillars/stop", headers: headers_with_access_key
      post "/caterpillars/start", headers: headers_with_access_key
      expect(response).to have_http_status(200)
      expect(response_body["caterpillar"]["pattern"]).to eq "1234"
      expect(response_body["timer"]["isRunning"]).to be_truthy
    end

    it "new caterpillar is created if last caterpillar has finished" do
      post "/caterpillars/finish", headers: headers_with_access_key
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
      expect(response).to have_http_status(200)
      expect(Caterpillar.count).to eq 2
    end

    it "headerにdata-access-keyを含めないとエラーになる" do
      post "/caterpillars/start", params: { pattern: "1234" }
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /caterpillars/stop" do
    before do
      Life.create_and_start
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
      post "/caterpillars/stop", headers: headers_with_access_key
    end

    it_behaves_like "returns caterpillars basic response"

    it "caterpillar has stopped" do
      caterpillar = Caterpillar.last
      expect(caterpillar.timer.stopped?).to be_truthy
    end

    it "access-keyなしだとエラーになる" do
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
      post "/caterpillars/stop"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /caterpillars/finish" do
    before do
      Life.create_and_start
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
      post "/caterpillars/finish", headers: headers_with_access_key
    end

    it_behaves_like "returns caterpillars basic response"

    it "caterpillar has finished" do
      caterpillar = Caterpillar.last
      expect(caterpillar.finished?).to be_truthy
    end

    it "Occur error if caterpillar has not started" do
      post "/caterpillars/finish", headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["Timer has already finished."]
    end

    it "access-keyなしだとエラーになる" do
      post "/caterpillars/start", params: { pattern: "1234" }, headers: headers_with_access_key
      post "/caterpillars/finish"
      expect(response).to have_http_status(401)
    end
  end
end
