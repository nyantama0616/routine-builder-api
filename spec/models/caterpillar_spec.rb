require 'rails_helper'

RSpec.describe Caterpillar, type: :model do
  it_behaves_like "timerable", Caterpillar, -> { Caterpillar.create_and_start!("1234") }
  
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

    it "info returns {pattern, passedSeconds}" do
      expect(@caterpillar.info.keys).to eq %i[pattern passedSeconds]
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
  end

  describe "class methods" do
    before do
      Life.create_and_start
    end

    it "create_and_start" do
      caterpillar = Caterpillar.create_and_start!("1234")
      expect(caterpillar.life).to eq Life.today
      expect(caterpillar.pattern).to eq "1234"
      expect(caterpillar.timer.started?).to eq true
    end

    it "all_patterns" do
      cat1234 = Caterpillar.create_and_start!("1234")
      Timecop.freeze(5.minute.from_now)
      cat1234.finish

      cat4321 = Caterpillar.create_and_start!("4321")
      Timecop.freeze(10.minute.from_now)
      cat4321.finish

      cat1234 = Caterpillar.create_and_start!("1234")
      Timecop.freeze(30.second.from_now)

      patterns = Caterpillar.all_patterns

      expect(patterns["1234"]).to eq 5*60 + 30
      expect(patterns["4321"]).to eq 10*60
      expect(patterns["1243"]).to eq 0
    end
  end
end
