require 'rails_helper'

RSpec.describe "Hiits", type: :request do
  describe "GET /hiits" do
    before do
      Life.create_and_start
      Hiit.update_setting!({ work_time: 10, break_time: 20, round_count: 30 })
      get "/hiits"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "returns hiit setting" do
      expect(response_body["hiitSetting"]).to eq Hiit.setting_info.stringify_keys
    end
  end

  describe "POST /hiits/start" do
    before do
      Life.create_and_start
      post "/hiits/start", params: { workTime: 2, breakTime: 3 }, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "round_count is set" do
      hiit = Hiit.last
      expect(hiit.round_count).to eq 0
    end

    it "work_time is set" do
      hiit = Hiit.last
      expect(hiit.work_time).to eq 2
    end

    it "break_time is set" do
      hiit = Hiit.last
      expect(hiit.break_time).to eq 3
    end

    it "returns hiit info" do
      hiit = Hiit.last
      
      expect(response_body["hiit"].except("startedAt")).to eq hiit.info.stringify_keys.except("startedAt")
      expect(response_body["hiit"]["startedAt"]).to be_present
    end

    it "access-keyなしだとエラーになる" do
      post "/hiits/start", params: { workTime: 2, breakTime: 3 }
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /hiits/finish" do
    before do
      Life.create_and_start
      Hiit.create_and_start!
      post "/hiits/finish", params: { roundCount: 10 }, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "hiit is finished" do
      hiit = Hiit.last
      expect(hiit.finished?).to be_truthy
    end

    it "round_count is set" do
      hiit = Hiit.last
      expect(hiit.round_count).to eq 10
    end

    it "returns hiit info" do
      hiit = Hiit.last
      expect(response_body["hiit"].except("startedAt", "finishedAt")).to eq hiit.info.stringify_keys.except("startedAt", "finishedAt")
      expect(response_body["hiit"]["startedAt"]).to be_present
      expect(response_body["hiit"]["finishedAt"]).to be_present
    end

    it "access-keyなしだとエラーになる" do
      post "/hiits/finish"
      expect(response).to have_http_status(401)
    end
  end

  describe "PATCH /hiits/settings" do
    before do
      Hiit.work_time = 1
      Hiit.break_time = 2
      Hiit.round_count = 3

      patch "/hiits/setting", params: { hiitSetting: { workTime: 10, breakTime: 20, roundCount: 30 } }, headers: headers_with_access_key
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "all settings are updated" do
      expect(Hiit.work_time).to eq 10
      expect(Hiit.break_time).to eq 20
      expect(Hiit.round_count).to eq 30
    end

    it "returns hiit setting" do
      expect(response_body["hiitSetting"]).to eq Hiit.setting_info.stringify_keys
    end

    it "access-keyなしだとエラーになる" do
      patch "/hiits/setting", params: { hiitSetting: { workTime: 10, breakTime: 20, roundCount: 30 } }
      expect(response).to have_http_status(401)
    end
  end
end
