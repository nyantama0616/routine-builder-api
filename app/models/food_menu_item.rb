class FoodMenuItem < ApplicationRecord
  belongs_to :food
  belongs_to :food_menu

  with_options presence: true do
    validates :food
    validates :food_menu
    validates :quantity
  end
end
