class CreateFoodMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :food_menus do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
