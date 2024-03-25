require 'rails_helper'

RSpec.describe Caterpillar, type: :model do
  describe "Validations" do
    before do
      Life.create_and_start
      @caterpillar = build(:caterpillar)
    end

    it "Factory is valid" do
      expect(@caterpillar).to be_valid
    end

    it "Life is required" do
      @caterpillar.life = nil
      expect(@caterpillar).to be_invalid
    end

    it "Pattern is required" do
      @caterpillar.pattern = nil
      expect(@caterpillar).to be_invalid
    end

    it "pattern is 4 digits" do
      @caterpillar.pattern = "123"
      expect(@caterpillar).to be_invalid
    end

    it "pattern is unique 4 digits" do
      @caterpillar.pattern = "1123"
      expect(@caterpillar).to be_invalid
    end

    it "pattern is 1-4" do
      @caterpillar.pattern = "1235"
      expect(@caterpillar).to be_invalid
    end
  end

  describe "other methods" do
    before do
      Life.create_and_start
      @caterpillar = Caterpillar.create_and_start!("1234")
    end

    it "create_and_start" do
      expect(@caterpillar.life).to eq Life.today
      expect(@caterpillar.pattern).to eq "1234"
      expect(@caterpillar.timer.started?).to eq true
    end

    it "info returns {pattern, passedSeconds}" do
      expect(@caterpillar.info.keys).to eq %i[pattern passedSeconds]
    end

    it "finished?" do
      expect(@caterpillar.finished?).to eq false
      @caterpillar.finish
      expect(@caterpillar.finished?).to eq true
    end
  end

  describe "associations" do
    before do
      Life.create_and_start
      @caterpillar = Caterpillar.create_and_start!("1234")
    end

    it "belongs_to :life" do
      expect(@caterpillar.life).to eq Life.today
    end

    it "has_one :timer" do
      expect(@caterpillar.timer).to eq Timer.last
    end

    it "destroy timer when destroy caterpillar" do
      expect(Timer.count).to eq 1
      @caterpillar.destroy
      expect(Timer.count).to eq 0
    end
  end
end
