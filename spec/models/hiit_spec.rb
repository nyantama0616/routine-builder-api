require 'rails_helper'

RSpec.describe Hiit, type: :model do
  describe "Validations" do
    before do
      @params = { round_count: 5, work_time: 30, break_time: 10, life: Life.create_and_start}
    end

    it "I can create a new Hiit with valid @params." do
      expect(Hiit.create(@params)).to be_valid
    end

    it "I can't create a new Hiit without round_count." do
      expect(Hiit.create(@params.except(:round_count))).to be_invalid
    end

    it "I can't create a new Hiit without work_time." do
      expect(Hiit.create(@params.except(:work_time))).to be_invalid
    end

    it "I can't create a new Hiit without break_time." do
      expect(Hiit.create(@params.except(:break_time))).to be_invalid
    end
  end

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
      @train = Hiit.create_train!({round_count: 1, work_time: 2, break_time: 3})
    end

    it "新しいTrainが作成される" do
      expect(Hiit.count).to eq 1
    end

    it "引数に渡したラウンド数が記録される" do
      expect(@train.round_count).to eq 1  
      expect(@train.work_time).to eq 2
      expect(@train.break_time).to eq 3
    end

    it "work_time, break_timeを省略した場合は、設定値が使われる" do
      train = Hiit.create_train!({round_count: 1})
      expect(train.work_time).to eq 30
      expect(train.break_time).to eq 10
    end

    it "今日のLifeに紐づく" do
      expect(@train.life).to eq Life.today
    end
  end

  describe "other methods" do
    before do
      create(:life)
      Hiit.work_time = 30
      Hiit.break_time = 10
      @train = Hiit.create_train!({round_count: 5})
    end

    it "info()で{workTime, breakTime, roundCount}が取得できる" do
      expect(@train.info).to eq({ workTime: 30, breakTime: 10, roundCount: 5 })
    end
  end
end
