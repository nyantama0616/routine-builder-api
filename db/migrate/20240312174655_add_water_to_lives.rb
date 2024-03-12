class AddWaterToLives < ActiveRecord::Migration[7.0]
  def change
    add_column :lives, :water, :integer, null: false, default: 0
  end
end
