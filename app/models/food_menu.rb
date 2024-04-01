# FoodMenuがa種類のFoodをb個ずつ持つ

class FoodMenu < ApplicationRecord
  has_many :food_menu_items, dependent: :destroy
  has_many :foods, through: :food_menu_items
  validates :name, presence: true

  def foods_with_quantity
    food_menu_items.map do |food_menu_item|
      {
        food: food_menu_item.food.info,
        quantity: food_menu_item.quantity
      }
    end
  end
end
