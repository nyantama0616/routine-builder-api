class FoodMenuItem < ApplicationRecord
  belongs_to :food
  belongs_to :food_menu

  with_options presence: true do
    validates :food
    validates :food_menu
    validates :quantity
  end

  validates :quantity, numericality: { greater_than: 0 }

  validates_uniqueness_of :food_id, scope: :food_menu_id
end
