class CreateHanons < ActiveRecord::Migration[7.0]
  def change
    create_table :hanons do |t|
      t.references :life, null: false, foreign_key: true
      t.integer :num, null: false
      t.string :pattern, null: false
      t.timestamps
    end
  end
end
