require 'rails_helper'

RSpec.describe FoodMenuItem, type: :model do
  describe 'validations' do
    before do
      @food_menu_item = create(:food_menu_item)
    end

    it "factory is valid" do
      expect(@food_menu_item).to be_valid
    end

    it "is invalid without a food" do
      @food_menu_item.food = nil
      @food_menu_item.valid?
      expect(@food_menu_item.errors[:food]).to include("can't be blank")
    end

    it "is invalid without a food_menu" do
      @food_menu_item.food_menu = nil
      @food_menu_item.valid?
      expect(@food_menu_item.errors[:food_menu]).to include("can't be blank")
    end

    it "is invalid without a quantity" do
      @food_menu_item.quantity = nil
      @food_menu_item.valid?
      expect(@food_menu_item.errors[:quantity]).to include("can't be blank")
    end
  end
end
