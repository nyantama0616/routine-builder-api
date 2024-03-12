require 'rails_helper'

RSpec.describe Life, type: :model do
  describe "#create" do
    before do
      @life = Life.create
    end
    
    it "default value of started_at is nil" do
      expect(@life.started_at).to be_nil  
    end
  
    it "default value of finished_at is nil" do
      expect(@life.finished_at).to be_nil  
    end

    it "Life.today returns last record" do
      create_list(:life, 3)
      expect(Life.today).to eq Life.last
    end
  end


  describe "#start" do
    before do
      @life = Life.create_and_start
    end

    it "started_at is current time" do
      expect(@life.started_at).to be_within(1.second).of(Time.current)
    end

    it "started_at is JST" do
      expect(@life.started_at.zone).to eq 'JST'
    end

    it "has_started? is true" do
      expect(@life.has_started?).to be_truthy
    end

    it "raise error if already started" do
      expect { @life.start }.to raise_error('already started')
    end

    it "raise error if already finished" do
      @life.finish
      expect { @life.start }.to raise_error('already finished')
    end
  end

  describe "#finish" do
    before do
      @life = Life.create_and_start
      @life.finish
    end

    it "finished_at is current time" do
      expect(@life.finished_at).to be_within(1.second).of(Time.current)
    end

    it "has_finished? is true" do
      expect(@life.has_finished?).to be_truthy
    end

    it "raise error if not started" do
      life = Life.create
      expect { life.finish }.to raise_error('not started')
    end

    it "raise error if already finished" do
      expect { @life.finish }.to raise_error('already finished')
    end
  end

  describe "other method" do
    before do
      @life = Life.create_and_start
    end

    it "#drink" do
      @life.drink(200)
      expect(@life.water).to eq 200
    end
  end
end
