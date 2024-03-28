require 'rails_helper'

RSpec.describe Hanon, type: :model do
  describe 'validations' do
    before do
      Life.create_and_start
      @build = {
        num: 1,
        pattern: "1:CM",
        life: Life.today,
      }
    end

    it "is valid with valid attributes" do
      expect(Hanon.new(@build)).to be_valid
    end

    it "is invalid with invalid num" do
      @build[:num] = 0
      expect(Hanon.new(@build)).to be_invalid
      
      @build[:num] = 21
      expect(Hanon.new(@build)).to be_invalid
    end

    it "is invalid with invalid pattern" do
      @build[:pattern] = "1:C"
      expect(Hanon.new(@build)).to be_invalid

      @build[:pattern] = "23:CM"
      expect(Hanon.new(@build)).to be_invalid

      @build[:pattern] = "1CM"
      expect(Hanon.new(@build)).to be_invalid
    end

    it "is invalid without life" do
      @build[:life] = nil
      expect(Hanon.new(@build)).to be_invalid
    end
  end

  describe 'associations' do
    before do
      Life.create_and_start
      @hanon = Hanon.create_and_start!(1, "1:CM")
    end

    it "belongs to life" do
      life = Life.today
      expect(@hanon.life).to eq life
    end

    it "has one timer" do
      expect(@hanon.timer).to be_present
    end

    it "destroys timer when destroyed" do
      timer = @hanon.timer
      @hanon.destroy
      expect(Timer.find_by(id: timer.id)).to be_nil
    end
  end

  describe 'methods' do
    before do
      Life.create_and_start
      @hanon = Hanon.create_and_start!(1, "1:CM")
    end

    it "info" do
      @hanon.stop
      expect(@hanon.info).to eq({
        num: @hanon.num,
        pattern: @hanon.pattern,
        passedSeconds: @hanon.timer.passed_seconds.to_i,
      })
    end

    it "start" do
      @hanon.stop
      @hanon.start
      expect(@hanon.timer.started?).to be_truthy
    end

    it "stop" do
      @hanon.stop
      expect(@hanon.timer.stopped?).to be_truthy
    end

    it "finish" do
      @hanon.finish
      expect(@hanon.timer.finished?).to be_truthy
    end
  end
end
