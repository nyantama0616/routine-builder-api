# TODO: 以下を追加
# 店名
# JANコード

class Food < ApplicationRecord
  has_many :food_menu_items, dependent: :destroy
  has_many :food_menus, through: :food_menu_items

  validates :name, presence: true
  validates :price, presence: true

  def info
    {
      id: id,
      name: name,
      abb_name: abb_name,
      price: price
    }
  end
end
