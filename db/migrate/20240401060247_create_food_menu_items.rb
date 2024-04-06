class CreateFoodMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :food_menu_items do |t|
      t.references :food_menu, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.float :quantity, null: false

      t.timestamps
    end
  end
end
