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

    it "started? is true" do
      expect(@life.started?).to be_truthy
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

    it "finished? is true" do
      expect(@life.finished?).to be_truthy
    end

    it "raise error if not started" do
      life = Life.create
      expect { life.finish }.to raise_error('not started')
    end

    it "raise error if already finished" do
      expect { @life.finish }.to raise_error('already finished')
    end
  end

  describe "#status" do
    before do
      @life = Life.create_and_start
    end

    it "status is none" do
      expect(@life.status).to eq "none"
    end

    it "status is Sleep When sleeping" do
      sleep = Sleep.create_and_start
      expect(@life.status).to eq Life::Status::Sleep
    end

    it "status is Nap When napping" do
      nap = Sleep.create_and_start(nap: true)
      expect(@life.status).to eq Life::Status::Nap

      nap.finish
      expect(@life.status).to eq Life::Status::None
    end

    it "status is Caterpillar When Caterpillar" do
      caterpillar = Caterpillar.create_and_start! pattern: "1234"
      expect(@life.status).to eq Life::Status::Caterpillar

      caterpillar.finish
      expect(@life.status).to eq Life::Status::None
    end

    it "status is Hanon When Hanon" do
      hanon = Hanon.create_and_start! num: 1, pattern: "1:CM"
      expect(@life.status).to eq Life::Status::Hanon

      hanon.finish
      expect(@life.status).to eq Life::Status::None
    end
  end

  describe "other method" do
    before do
      @life = Life.create_and_start
    end

    it "#drink" do
      @life.drink_water(200)
      expect(@life.water).to eq 200
    end

    it "#info" do
      info = @life.info
      expect(info[:startedAt]).to be_within(1.second).of(@life.started_at)
      expect(info[:status]).to eq @life.status
    end
  end
end
