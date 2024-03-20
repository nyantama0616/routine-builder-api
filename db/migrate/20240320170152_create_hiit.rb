class CreateHiit < ActiveRecord::Migration[7.0]
  def change
    create_table :hiits do |t|
      t.references :life, null: false, foreign_key: true
      t.integer :work_time, null: false
      t.integer :break_time, null: false
      t.integer :round_count, null: false
      t.timestamps
    end
  end
end
