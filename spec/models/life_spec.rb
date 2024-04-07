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

    it "Life.today returns latest record" do
      @life.destroy
      3.times do
        Timecop.freeze(1.day.from_now)
        Life.create_and_start
      end
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

    it "status is Tooth When Tooth" do
      tooth = Tooth.create_and_start!
      expect(@life.status).to eq Life::Status::Tooth

      tooth.finish
      expect(@life.status).to eq Life::Status::None
    end

    it "status is Hiit When Hiit" do
      hiit = Hiit.create_and_start! work_time: 30, break_time: 30
      expect(@life.status).to eq Life::Status::Hiit

      hiit.finish 1
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
      expect(info[:wakedUpAt]).to be_within(1.second).of(@life.started_at)
      expect(info[:wentToBedAt]).to be_nil
      expect(info[:sleepSeconds]).to eq 0
      expect(info[:water]).to eq @life.water
      expect(info[:trainSeconds]).to eq @life.train_seconds
    end

    it "train_seconds" do
      hiit = Hiit.create_and_start!
      hanon = Hanon.create_and_start! num: 1, pattern: "1:CM"
      caterpillar = Caterpillar.create_and_start! pattern: "1234"
      
      Timecop.freeze(10.minute.from_now)
      
      hiit.finish 1
      hanon.finish
      caterpillar.finish

      hiit = Hiit.create_and_start!
      hanon = Hanon.create_and_start! num: 1, pattern: "1:CM"
      caterpillar = Caterpillar.create_and_start! pattern: "1234"
      
      Timecop.freeze(20.minute.from_now)
      
      hiit.finish 1
      hanon.finish
      caterpillar.finish
      
      expect(@life.reload.train_seconds.values).to all(eq(30.minutes))
    end
  end

  describe "associations" do
    before do
      @life = Life.create_and_start
    end

    it "has_many :sleeps" do
      2.times do
        sleep = Sleep.create_and_start nap: true
        sleep.finish
      end

      expect(@life.sleeps.length).to eq 2
    end

    it "has_many :caterpillars" do
      2.times do
        caterpillar = Caterpillar.create_and_start! pattern: "1234"
        caterpillar.finish
      end

      expect(@life.caterpillars.length).to eq 2
    end

    it "has_many :hiits" do
      2.times do
        hiit = Hiit.create_and_start! work_time: 30, break_time: 30
        hiit.finish 1
      end

      expect(@life.hiits.length).to eq 2
    end

    it "has_many :hanons" do
      2.times do
        hanon = Hanon.create_and_start! num: 1, pattern: "1:CM"
        hanon.finish
      end

      expect(@life.hanons.length).to eq 2
    end
  end
end
