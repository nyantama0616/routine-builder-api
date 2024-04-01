module FoodCost::FoodMenu::ClassMethods
  extend ActiveSupport::Concern

  class_methods do
    def create_menu!(name:, foods: [])
      food_menu = FoodMenu.create!(name: name)

      foods.each do |food|
        food_menu.add_food(food[:id], food[:quantity])
      end

      food_menu
    end
  end
end
