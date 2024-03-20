require 'rails_helper'

RSpec.describe Hiit, type: :model do
  describe "Settings" do
    before do
      Hiit.work_time = 0
      Hiit.break_time = 0
      Hiit.round_count = 0
    end
  
    it "I can get hiit settings." do
      expect(Hiit.work_time).to eq 0
      expect(Hiit.break_time).to eq 0
      expect(Hiit.round_count).to eq 0
    end

    it "I can set hiit settings." do
      Hiit.work_time = 1
      Hiit.break_time = 2
      Hiit.round_count = 3
      expect(Hiit.work_time).to eq 1
      expect(Hiit.break_time).to eq 2
      expect(Hiit.round_count).to eq 3
    end
  end

  describe "Create Train" do
    before do
      create(:life)
      Hiit.work_time = 30
      Hiit.break_time = 10
      @train = Hiit.create_train!(5)
    end

    it "新しいTrainが作成される" do
      expect(Hiit.count).to eq 1
    end

    it "設定の内容がTrainに反映され、引数に渡したラウンド数が記録される" do
      expect(@train.work_time).to eq 30
      expect(@train.break_time).to eq 10
      expect(@train.round_count).to eq 5  
    end

    it "今日のLifeに紐づく" do
      expect(@train.life).to eq Life.today
    end
  end
end
