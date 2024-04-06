class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.string :abb_name
      t.float :price, null: false

      t.timestamps
    end
  end
end
