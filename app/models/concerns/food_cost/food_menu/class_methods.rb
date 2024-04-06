module FoodCost::FoodMenu::ClassMethods
  extend ActiveSupport::Concern

  class_methods do
    def create_menu!(name:, foods: [])
      food_menu = FoodMenu.create!(name: name)

      foods.each do |food|
        food_menu.add_food(food[:id].to_i, food[:quantity].to_f) #TODO: ここでto_xするべきなのか？
      end
      
      food_menu
    end
  end
end
