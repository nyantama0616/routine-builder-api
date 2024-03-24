require 'rails_helper'

RSpec.describe Timer, type: :model do
  describe 'validations' do
    before do
      @timer = build(:timer)
    end

    it "default timer is not running" do
      expect(@timer.running?).to be false
    end

    it "default timer has not passed any seconds" do
      expect(@timer.passed_seconds).to eq 0
    end
  end

  describe 'start' do
    before do
      @timer = create(:timer)
      @timer.start
    end

    it "timer is running" do
      expect(@timer.running?).to be true
    end

    it "timer has passed some seconds" do
      Timecop.freeze(Time.current + 10) do
        expect(@timer.passed_seconds).to eq 10
      end
    end

    it "started_at is current" do
      expect(@timer.started_at).to be_within(1.second).of(Time.current)
    end

    it "started? is true" do
      expect(@timer.started?).to be true
    end

    it "raises error if timer has already started" do
      expect { @timer.start }.to raise_error("Timer has already started.")
    end

    it "raises error if timer has already finished" do
      @timer.finish
      expect { @timer.start }.to raise_error("Timer has already finished.")
    end
  end

  describe 'stop' do
    before do
      @timer = create(:timer)
      @timer.start
      Timecop.freeze(Time.current + 10) do
        @timer.stop
      end
    end

    it "timer is not running" do
      expect(@timer.running?).to be false
    end

    it "timer has passed some seconds" do
      expect(@timer.passed_seconds).to eq 10
    end

    it "stopped? is true" do
      expect(@timer.stopped?).to be true
    end

    it "raises error if timer has not started" do
      expect { @timer.stop }.to raise_error("Timer has not started.")
    end

    it "raises error if timer has already finished" do
      @timer.start
      @timer.finish
      expect { @timer.stop }.to raise_error("Timer has already finished.")
    end
  end

  describe 'finish' do
    before do
      @timer = create(:timer)
      @timer.start
      Timecop.freeze(Time.current + 10) do
        @timer.finish
      end
    end

    it "timer is not running" do
      expect(@timer.running?).to be false
    end

    it "timer has passed some seconds" do
      expect(@timer.passed_seconds).to eq 10
    end

    it "finished_at is current + 10" do
      expect(@timer.finished_at).to be_within(1.second).of(Time.current + 10)
    end

    it "finished? is true" do
      expect(@timer.finished?).to be true
    end

    it "raises error if timer has not started" do
      timer = create(:timer)
      expect { timer.finish }.to raise_error("Timer has not started.")
    end

    it "raises error if timer has already finished" do
      expect { @timer.finish }.to raise_error("Timer has already finished.")
    end
  end
end
