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
      expect(@caterpillar.started_at).to be_within(1.second).of(Time.current)
    end

    it "info returns {pattern, startedAt, finishedAt}" do
      expect(@caterpillar.info.keys).to eq %i[pattern startedAt finishedAt]
    end

    it "finish" do
      @caterpillar.finish
      expect(@caterpillar.finished_at).to be_within(1.second).of(Time.current)
    end
  end
end
