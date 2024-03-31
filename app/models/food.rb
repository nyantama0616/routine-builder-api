# TODO: 以下を追加
# 店名
# JANコード

class Food < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true

  def info
    {
      name: name,
      abb_name: abb_name,
      price: price
    }
  end
end
