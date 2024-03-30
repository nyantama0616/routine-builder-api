require 'rails_helper'

RSpec.shared_examples "returns hanons basic response" do
  it "returns 200" do
    expect(response).to have_http_status(200)
  end

  it "returns hanon info" do
    hanon = Hanon.last
    expect(response_body["hanon"]).to eq hanon.info.as_json
  end

  it_behaves_like "timerable request", Hanon
end

RSpec.describe "Hanons", type: :request do
  describe "GET /hanons" do
    before do
      Life.create_and_start
      @hanon = Hanon.create_and_start!(1, "1:CM")
      get "/hanons"
    end
    
    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns hanon in progress" do
      in_progress = response_body["inProgress"]
      expect(in_progress["hanon"]["pattern"]).to eq @hanon.pattern
      expect(in_progress["timer"]["isRunning"]).to be true

      @hanon.finish
      get "/hanons"
      in_progress = response_body["inProgress"]
      expect(in_progress).to be_nil
    end

    it "returns all patterns" do
      patterns = response_body["patterns"]
      expect(patterns).to eq Hanon.all_patterns.stringify_keys
    end
  end

  describe "POST /hanons/start" do
    before do
      Life.create_and_start
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }, headers: headers_with_access_key
    end

    it_behaves_like "returns hanons basic response"

    it "Occur error if last hanon has not finished" do
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }, headers: headers_with_access_key
      expect(response).to have_http_status(400)
      expect(response_body["errors"]).to eq ["Timer has already started."]
    end

    it "returns 400 if num is not present" do
      Hanon.last.finish
      post "/hanons/start", params: { pattern: "1:CM" }, headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "returns 400 if pattern is not present" do
      Hanon.last.finish
      post "/hanons/start", params: { num: 1 }, headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "can restart after stop" do
      post "/hanons/stop", headers: headers_with_access_key
      post "/hanons/start", headers: headers_with_access_key
      expect(response).to have_http_status(200)
    end

    it "access-keyなしだとエラーになる" do
      Hanon.last.finish
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /hanons/stop" do
    before do
      Life.create_and_start
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }, headers: headers_with_access_key
      post "/hanons/stop", headers: headers_with_access_key
    end

    it_behaves_like "returns hanons basic response"

    it "returns 400 if hanon has not started" do
      post "/hanons/stop", headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "access-keyなしだとエラーになる" do
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }, headers: headers_with_access_key
      post "/hanons/stop"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /hanons/finish" do
    before do
      Life.create_and_start
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }, headers: headers_with_access_key
      post "/hanons/finish", headers: headers_with_access_key
    end

    it_behaves_like "returns hanons basic response"

    it "returns 400 if hanon has not started" do
      post "/hanons/finish", headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "access-keyなしだとエラーになる" do
      post "/hanons/start", params: { num: 1, pattern: "1:CM" }, headers: headers_with_access_key
      post "/hanons/finish"
      expect(response).to have_http_status(401)
    end
  end
end
