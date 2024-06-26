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
      sleep = response_body["sleep"]
      expect(sleep).to eq(@latest_sleep.info.as_json)
    end
  end

  describe "POST /sleeps/start" do
    before do
      Life.create_and_start
      post '/sleeps/start', headers: headers_with_access_key
      @sleep = Sleep.last
    end

    it "returns 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the latest sleep" do
      sleep = response_body["sleep"]
      expect(sleep).to eq(@sleep.info.as_json)
    end

    it "2回目のリクエストでエラーになる" do
      post '/sleeps/start', headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "defaultではnap?がfalseである" do
      sleep = response_body["sleep"]
      expect(sleep["isNap"]).to eq(false)
    end

    it "nap: trueで実行すると、nap?がtrueになる" do
      post "/sleeps/finish", headers: headers_with_access_key
      post '/sleeps/start', params: { isNap: true }, headers: headers_with_access_key
      
      expect(response_body["sleep"]["isNap"]).to eq(true)
    end

    it "statusが返ってくる" do
      expect(response_body["status"]).to eq(Life.today.status)
    end

    it "headerにdata-access-keyを含めないとエラーになる" do
      post '/sleeps/finish', headers: headers_with_access_key
      post '/sleeps/start'
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /sleeps/finish" do
    before do
      Life.create_and_start
      post '/sleeps/start', headers: headers_with_access_key
      post '/sleeps/finish', headers: headers_with_access_key
      @sleep = Sleep.last
    end

    it "returns 200 OK" do
      expect(response).to have_http_status(200)
    end

    it "returns the latest sleep" do
      expect(response_body["sleep"]).to eq(@sleep.info.as_json)
    end

    it "2回目のリクエストでエラーになる" do
      post '/sleeps/finish', headers: headers_with_access_key
      expect(response).to have_http_status(400)
    end

    it "statusが返ってくる" do
      expect(response_body["status"]).to eq(Life.today.status)
    end

    it "headerにdata-access-keyを含めないとエラーになる" do
      post '/sleeps/start', headers: headers_with_access_key
      post '/sleeps/finish'
      expect(response).to have_http_status(401)
    end
  end
end
