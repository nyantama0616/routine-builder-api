# FoodMenuがa種類のFoodをb個ずつ持つ

class FoodMenu < ApplicationRecord
  include FoodCost::FoodMenu::ClassMethods
  
  has_many :food_menu_items, dependent: :destroy
  has_many :foods, through: :food_menu_items
  validates :name, presence: true

  def food_ids_with_quantity
    food_menu_items.map do |food_menu_item|
      {
        foodId: food_menu_item.food_id,
        quantity: food_menu_item.quantity
      }
    end
  end

  # TODO: エラーハンドリングするべきか？
  def add_food(food_id, quantity)
    if food = Food.find_by(id: food_id)
      food_menu_items.create(food: food, quantity: quantity)
    end
  end

  def remove_food(food_id)
    if item = food_menu_items.find_by(food_id: food_id)
      item.destroy
    end
  end

  #TODO: 最適化する
  def update_menu!(name: nil, foods: nil)
    update!(name: name) if name

    if foods
      food_menu_items.destroy_all

      foods.each do |food|
        add_food(food[:id], food[:quantity])
      end
    end
  end

  def info(only: %i(id name foods))
    res = {
      id: id,
      name: name,
      foods: food_ids_with_quantity
    }
    res.slice(*only)
  end
end
