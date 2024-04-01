require 'rails_helper'

RSpec.describe FoodMenu, type: :model do
  describe 'validations' do
    before do
      @food_menu = create(:food_menu)
    end

    it "is valid with a name" do
      expect(@food_menu).to be_valid
    end

    it "is invalid without a name" do
      @food_menu.name = nil
      @food_menu.valid?
      expect(@food_menu.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    before do
      @food_menu = create(:food_menu)
      @food = create(:food)
      @food_menu_item = create(:food_menu_item, food_menu: @food_menu, food: @food)
    end

    it "has many food_menu_items" do
      expect(@food_menu.food_menu_items).to include(@food_menu_item)
    end

    it "has many food through food_menu_items" do
      expect(@food_menu.foods).to include(@food)
    end

    it "FoodMenuをdestroyすると、food_menu_itemsをdestroyされる" do
      food_menu_items = @food_menu.food_menu_items
      @food_menu.destroy
      food_menu_items.each do |food_menu_item|
        expect(FoodMenuItem.find_by(id: food_menu_item.id)).to be_nil
      end
    end
  end

  describe 'methods' do
    before do
      @food_menu = create(:food_menu)
      @food = create(:food)
      @food_menu_item = create(:food_menu_item, food_menu: @food_menu, food: @food, quantity: 3)
    end

    it "foods_with_quantity" do
      expect(@food_menu.foods_with_quantity).to include({food: @food.info, quantity: 3})
    end

    it "info returns {id, name, foods}" do
      expect(@food_menu.info).to eq({id: @food_menu.id, name: @food_menu.name, foods: @food_menu.foods_with_quantity})
    end

    it "add_food" do
      food = create(:food)
      @food_menu.add_food(food.id, 2)
      expect(@food_menu.foods_with_quantity).to include({food: food.info, quantity: 2})
    end

    it "remove_food" do
      @food_menu.remove_food(@food.id)
      expect(@food_menu.foods).not_to include(@food)
    end

    it "update_food_quantity" do
      @food_menu.update_food_quantity(@food.id, 5)
      expect(@food_menu.food_menu_items.find_by(food_id: @food.id).quantity).to eq(5)
    end
  end
end
