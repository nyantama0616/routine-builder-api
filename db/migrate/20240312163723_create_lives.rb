class CreateLives < ActiveRecord::Migration[7.0]
  def change
    create_table :lives do |t|
      t.datetime :started_at # 起床時刻
      t.datetime :finished_at # 次の日の起床時刻
      t.timestamps
    end
  end
end
