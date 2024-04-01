require 'rails_helper'

RSpec.describe Food, type: :model do
  describe "validations" do
    before do
      @food = build(:food)
    end
    
    it "is valid with a name, abb_name, price" do
      expect(@food).to be_valid
    end

    it "is invalid without a name" do
      @food.name = nil
      @food.valid?
      expect(@food.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a price" do
      @food.price = nil
      @food.valid?
      expect(@food.errors[:price]).to include("can't be blank")
    end
  end

  describe "methods" do
    before do
      @food = create(:food)
    end

    it "returns {id, name, abb_name, price}" do
      expect(@food.info).to eq({id: @food.id, name: @food.name, abb_name: @food.abb_name, price: @food.price})
    end
  end
end
