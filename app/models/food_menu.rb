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

  def add_food(food_id, quantity)
    if food = Food.find_by(id: food_id)
      food_menu_items.create!(food: food, quantity: quantity)
    else
      raise "Food not found"
    end
  end

  def remove_food(food_id)
    if item = food_menu_items.find_by(food_id: food_id)
      item.destroy
    else
      raise "Food not found"
    end
  end

  def update_food_quantity(food_id, quantity)
    if item = food_menu_items.find_by(food_id: food_id)
      item.update!(quantity: quantity)
    else
      raise "Food not found"
    end
  end

  def info
    {
      id: id,
      name: name,
      foods: foods_with_quantity
    }
  end
end
