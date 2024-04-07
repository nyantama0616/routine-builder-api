require 'rails_helper'

RSpec.describe Sleep, type: :model do
  describe "#create" do
    before do
      @sleep = create(:sleep)
    end
  
    it "started_atがデフォルトでnilであること" do
      expect(@sleep.started_at).to eq nil
    end
  
    it "finished_atがデフォルトでnilであること" do
      expect(@sleep.finished_at).to eq nil
    end
  
    it "nap?がdefaultでfalseであること" do
      expect(@sleep.nap?).to eq false
    end
  
    it "infoで、startedAt, finishedAt, isNapを返す" do
      expect(@sleep.info).to eq({
        startedAt: @sleep.started_at,
        finishedAt: @sleep.finished_at,
        isNap: @sleep.nap?,
      })
    end

    it "lifeがない場合、エラーになる" do
      expect { create(:sleep, life: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#start" do
    before do
      @sleep = create(:sleep)
      @sleep.start
    end
    
    it "sleep#startで、started_atが現在時刻(Tokyo)になり、nap?がfalseになる" do
      expect(@sleep.started_at).to be_within(1.second).of(Time.current)
      expect(@sleep.started_at.zone).to eq 'JST'
      expect(@sleep.nap?).to eq false
    end
  
    it "sleep#start(nap: true)で、nap?がtrueになる" do
      sleep = create(:sleep)
      sleep.start(nap: true)
      expect(sleep.nap?).to eq true
    end

    it "started?がtrueになる" do
      expect(@sleep.started?).to eq true
    end
  
    it "sleep#startを2回実行すると、エラーになる" do
      expect { @sleep.start }.to raise_error('already started')
    end
  
    it "finish済みの状態でsleep#startを実行すると、エラーになる" do
      @sleep.finish
      expect { @sleep.start }.to raise_error('already finished')
    end
  end

  describe "#finish" do
    before do
      @sleep = create(:sleep)
      @sleep.start
      @sleep.finish
    end

    it "finished_atが現在時刻になる" do
      expect(@sleep.finished_at).to be_within(1.second).of(Time.current)
    end

    it "finished?がtrueになる" do
      expect(@sleep.finished?).to eq true
    end
  
    it "sleep#startを実行する前に実行すると、エラーになる" do
      sleep = create(:sleep)
      expect { sleep.finish }.to raise_error('not started')
    end
  
    it "2回実行すると、エラーになる" do
      expect { @sleep.finish }.to raise_error('already finished')
    end

    it "nap=falseの場合、新しいLifeが作成される" do
      sleep = create(:sleep)
      sleep.start
      expect { sleep.finish }.to change { Life.count }.by(1)
      expect(Life.today.started_at).to be_within(1.second).of(Time.current)
    end
  end

  describe "other methods" do
    before do
      Life.create_and_start
      @sleep = Sleep.create_and_start
    end

    it "passed_secondsで経過時間が取得できる" do
      Timecop.freeze(Time.current + 10.minutes) do
        @sleep.finish
        expect(@sleep.passed_seconds).to eq 10.minutes
      end
    end
  end
end
