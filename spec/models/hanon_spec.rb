require 'rails_helper'

RSpec.describe Hanon, type: :model do
  it_behaves_like "timerable", -> { Hanon.create_and_start!(1, "1:CM") }

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
  end

  describe "class methods" do
    before do
      Life.create_and_start
    end

    it "all_patterns" do
      hanon1_1CM = Hanon.create_and_start!(1, "1:CM")
      Timecop.freeze(5.minute.from_now)
      hanon1_1CM.finish

      hanon3_5DSharpm = Hanon.create_and_start!(3, "5:D#m")
      Timecop.freeze(10.minute.from_now)
      hanon3_5DSharpm.finish

      hanon1_1CM = Hanon.create_and_start!(1, "1:CM")
      Timecop.freeze(30.second.from_now)

      patterns = Hanon.all_patterns

      expect(patterns[1]["1:CM"]).to eq 5*60 + 30
      expect(patterns[3]["5:D#m"]).to eq 10*60
      expect(patterns[1]["1:Cm"]).to eq 0
    end

    it "in_progress" do
      expect(Hanon.in_progress).to eq nil

      hanon = Hanon.create_and_start!(1, "1:CM")
      expect(Hanon.in_progress).to eq hanon

      hanon.finish
      expect(Hanon.in_progress).to eq nil
    end
  end
end
