require 'rails_helper'

RSpec.describe Walk, type: :model do
  it_behaves_like "timerable", Walk, -> { Walk.create_and_start! from: "home", to: "fun" }
  
  describe "validations" do
    before do
      Life.create_and_start
      @params = {
        from: "home",
        to: "fun",
      }
    end

    it "is valid with valid attributes" do
      expect { Walk.create_and_start! **@params }.to change { Walk.count }.by(1)
    end

    it "home must be one of Walk::Place" do
      @params[:from] = "hoge"
      expect { Walk.create_and_start! **@params }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "to must be one of Walk::Place" do
      @params[:to] = "hoge"
      expect { Walk.create_and_start! **@params }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "from and to must be different" do
      @params[:to] = "home"
      expect { Walk.create_and_start! **@params }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "associations" do
    before do
      Life.create_and_start
      @walk = Walk.create_and_start! from: "home", to: "fun"
    end

    it "belongs to life" do
      life = Life.today
      expect(@walk.life).to eq life
    end
  end

  describe "other methods" do
    before do
      Life.create_and_start
      @walk = Walk.create_and_start! from: "home", to: "fun"
    end

    it "info returns passed_seconds" do
      info = @walk.info
      expect(info[:passedSeconds]).to eq @walk.passed_seconds
    end
  end
end
