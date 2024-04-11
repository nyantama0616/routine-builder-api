require 'rails_helper'

RSpec.shared_examples "returns walks basic response" do
  it "returns 200" do
    expect(response).to have_http_status(200)
  end

  it "returns walk info" do
    walk = Walk.last
    expect(response_body["walk"]).to eq walk.info.as_json
  end

  it_behaves_like "timerable request", Walk
end

RSpec.describe "Walks", type: :request do
  describe "post /walks/start" do
    before do
      Life.create_and_start
      post "/walks/start", params: { walk: {from: "home", to: "fun"} }, headers: headers_with_access_key
    end

    it_behaves_like "returns walks basic response"

    it "Occur error if last walk has not finished" do
      post "/walks/start", params: { walk: {from: "home", to: "fun"} }, headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["Timer has already started."]
    end

    it "returns 400 if params is invalid" do
      Walk.last.finish
      post "/walks/start", params: { walk: {from: "home"} }, headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["missing keyword: :to"]
    end

    it "can restart after stop" do
      post "/walks/stop", headers: headers_with_access_key
      post "/walks/start", params: { walk: {from: "home", to: "fun"} }, headers: headers_with_access_key
      expect(response).to have_http_status(200)
    end

    it "access key is required" do
      Walk.last.finish
      post "/walks/start", params: { walk: {from: "home", to: "fun"} }
      expect(response).to have_http_status(401)
    end
  end

  describe "post /walks/stop" do
    before do
      Life.create_and_start
      post "/walks/start", params: { walk: {from: "home", to: "fun"} }, headers: headers_with_access_key
      post "/walks/stop", headers: headers_with_access_key
    end

    it_behaves_like "returns walks basic response"

    it "returns 400 if last walk has not started" do
      post "/walks/stop", headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["Timer has not started."]
    end

    it "access key is required" do
      post "/walks/stop"
      expect(response).to have_http_status(401)
    end
  end

  describe "post /walks/finish" do
    before do
      Life.create_and_start
      post "/walks/start", params: { walk: {from: "home", to: "fun"} }, headers: headers_with_access_key
      post "/walks/finish", headers: headers_with_access_key
    end

    it_behaves_like "returns walks basic response"

    it "returns 400 if last walk has not started" do
      post "/walks/finish", headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["Timer has already finished."]
    end

    it "access key is required" do
      Walk.create_and_start! from: "home", to: "fun"
      post "/walks/finish"
      expect(response).to have_http_status(401)
    end
  end
end
