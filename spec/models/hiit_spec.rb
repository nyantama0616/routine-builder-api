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

    it "integer以外の値を設定しようとするとエラーが発生する" do
      expect{ Hiit.work_time = "1" }.to raise_error(RuntimeError)
    end

    it "update setting" do
      Hiit.update_setting!({work_time: 10, break_time: 20, round_count: 30})
      expect(Hiit.work_time).to eq 10
      expect(Hiit.break_time).to eq 20
      expect(Hiit.round_count).to eq 30
    end

    it "break_timeが省略された場合は、break_timeは変更されない" do
      Hiit.update_setting!({work_time: 10, round_count: 30})
      expect(Hiit.work_time).to eq 10
      expect(Hiit.break_time).to eq 0
      expect(Hiit.round_count).to eq 30
    end

    it "setting_info" do
      Hiit.update_setting!({work_time: 10, break_time: 20, round_count: 30})
      expect(Hiit.setting_info).to eq({roundCount: 30, workTime: 10, breakTime: 20})
    end
  end

  describe "create_and_start!" do
    before do
      create(:life)
      Hiit.work_time = 30
      Hiit.break_time = 10
      @train = Hiit.create_and_start! work_time: 2, break_time: 3
    end

    it "新しいTrainが作成される" do
      expect(Hiit.count).to eq 1
    end

    it "引数に渡したラウンド数が記録される" do
      expect(@train.round_count).to eq 0
      expect(@train.work_time).to eq 2
      expect(@train.break_time).to eq 3
    end

    it "work_time, break_timeを省略した場合は、設定値が使われる" do
      train = Hiit.create_and_start!
      expect(train.work_time).to eq 30
      expect(train.break_time).to eq 10
    end

    it "started_atを取得できる" do
      expect(@train.started_at).to eq @train.created_at
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
      @train = Hiit.create_and_start!
    end

    it "info()で{workTime, breakTime, roundCount, startedAt, finishedAt}が取得できる" do
      expect(@train.info).to eq({ workTime: @train.work_time, breakTime: @train.break_time, roundCount: @train.round_count, startedAt: @train.created_at, finishedAt: nil })
    end

    it "finish()でfinished_atが記録される" do
      @train.finish 5
      expect(@train.finished_at).not_to be_nil
    end

    it "finish()を2回実行するとエラーが発生する" do
      @train.finish 5
      expect{ @train.finish 5 }.to raise_error(RuntimeError)
    end

    it "passed_seconds()で経過時間が取得できる" do
      Timecop.freeze(Time.current + 10.minutes) do
        @train.finish 5
        expect(@train.passed_seconds).to eq 10 * 60
      end
    end
  end
end
