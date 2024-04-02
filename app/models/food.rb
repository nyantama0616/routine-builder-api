# TODO: 以下を追加
# 店名
# JANコード

class Food < ApplicationRecord
  has_many :food_menu_items, dependent: :destroy
  has_many :food_menus, through: :food_menu_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def info(only: %i(id name abb_name price))
    hash = {
      id: id,
      name: name,
      abb_name: abb_name,
      price: price
    }
    hash.slice(*only)
  end
end
