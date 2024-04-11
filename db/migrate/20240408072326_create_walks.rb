class CreateWalks < ActiveRecord::Migration[7.0]
  def change
    create_table :walks do |t|
      t.references :life, null: false, foreign_key: true
      t.string :from, null: false
      t.string :to, null: false
      t.timestamps
    end
  end
end
