FactoryBot.define do
  factory :food_menu_item do
    food_menu { create(:food_menu) }
    food { create(:food) }
    quantity { 1 }
  end
end
