require 'rails_helper'

RSpec.describe "Sleeps", type: :request do
  describe "GET /sleeps/latest" do
    before do
      life = create(:life)
      sleeps = create_list(:sleep, 3, life: life)
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
      Life.create_and_start
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

    it "defaultではnap?がfalseである" do
      sleep = JSON.parse(response.body)["sleep"]
      expect(sleep["isNap"]).to eq(false)
    end

    it "nap: trueで実行すると、nap?がtrueになる" do
      post "/sleeps/finish"
      post '/sleeps/start', params: { isNap: true }
      
      sleep = JSON.parse(response.body)["sleep"]
      expect(sleep["isNap"]).to eq(true)
    end

    it "todayLifeが返ってくる" do
      json = JSON.parse(response.body)["todayLife"]
      expect(json).to eq(Life.today.info.as_json)
    end
  end

  describe "POST /sleeps/finish" do
    before do
      Life.create_and_start
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

    it "todayLifeが返ってくる" do
      json = JSON.parse(response.body)["todayLife"]
      expect(json).to eq(Life.today.info.as_json)
    end
  end
end
