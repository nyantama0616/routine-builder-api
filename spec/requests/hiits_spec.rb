require 'rails_helper'

RSpec.describe "Hiits", type: :request do
  describe "POST /hiits" do
    before do
      Life.create_and_start
      post "/hiits", params: { hiit: { roundCount: 1, workTime: 2, breakTime: 3 } }
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "round_count is set" do
      hiit = Hiit.last
      expect(hiit.round_count).to eq 1
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
      json = JSON.parse(response.body)
      hiit = Hiit.last
      
      expect(json["hiit"]).to eq hiit.info.stringify_keys
    end
  end

  describe "PATCH /hiits/settings" do
    before do
      Hiit.work_time = 1
      Hiit.break_time = 2
      Hiit.round_count = 3

      patch "/hiits/setting", params: { hiit: { workTime: 10, breakTime: 20, roundCount: 30 } }
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
      json = JSON.parse(response.body)
      expect(json["hiitSetting"]).to eq Hiit.setting_info.stringify_keys
    end
  end
end
