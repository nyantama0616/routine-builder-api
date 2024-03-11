require 'rails_helper'

RSpec.describe "Sleeps", type: :request do
  describe "GET /sleeps/latest" do
    before do
      sleeps = create_list(:sleep, 3)
      @latest_sleep = sleeps.last
      get '/sleeps/latest'
    end

    it "returns 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the latest sleep" do
      sleep = JSON.parse(response.body)["sleep"]
      expect(sleep).to eq(@latest_sleep.info.as_json)
    end
  end

  describe "POST /sleeps/start" do
    before do
      post '/sleeps/start'
      @sleep = Sleep.last
    end

    it "returns 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the latest sleep" do
      sleep = JSON.parse(response.body)["sleep"]
      expect(sleep).to eq(@sleep.info.as_json)
    end

    it "2回目のリクエストでエラーになる" do
      post '/sleeps/start'
      expect(response).to have_http_status(400)
    end
  end

  describe "POST /sleeps/finish" do
    before do
      post '/sleeps/start'
      post '/sleeps/finish'
      @sleep = Sleep.last
    end

    it "returns 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the latest sleep" do
      sleep = JSON.parse(response.body)["sleep"]
      expect(sleep).to eq(@sleep.info.as_json)
    end

    it "2回目のリクエストでエラーになる" do
      post '/sleeps/finish'
      expect(response).to have_http_status(400)
    end
  end
end
