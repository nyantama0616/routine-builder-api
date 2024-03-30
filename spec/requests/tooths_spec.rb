require 'rails_helper'

RSpec.shared_examples 'returns tooths basic response' do
  it "returns 200" do
    expect(response).to have_http_status(200)
  end

  it_behaves_like "timerable request", Tooth
end

RSpec.describe "Tooths", type: :request do
  describe "GET /tooths" do
    before do
      Life.create_and_start
      @tooth = Tooth.create_and_start!
      get "/tooths"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns tooth in progress" do
      in_progress = response_body["inProgress"]
      expect(in_progress["timer"]["isRunning"]).to be true

      Tooth.last.finish
      get "/tooths"
      in_progress = response_body["inProgress"]
      expect(in_progress).to be_nil
    end
  end

  describe "POST /tooths/start" do
    before do
      Life.create_and_start
      post "/tooths/start", headers: headers_with_access_key
    end

    it_behaves_like 'returns tooths basic response'
  end

  describe "POST /tooths/stop" do
    before do
      Life.create_and_start
      Tooth.create_and_start!
      post "/tooths/stop", headers: headers_with_access_key
    end

    it_behaves_like 'returns tooths basic response'
  end

  describe "POST /tooths/finish" do
    before do
      Life.create_and_start
      Tooth.create_and_start!
      post "/tooths/finish", headers: headers_with_access_key
    end

    it_behaves_like 'returns tooths basic response'
  end
end
