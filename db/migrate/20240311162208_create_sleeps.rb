class CreateSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :sleeps do |t|
      t.datetime :started_at # 就寝時刻
      t.datetime :finished_at # 起床時刻
      t.boolean :nap, null: false, default: false # 昼寝かどうか

      t.timestamps
    end
  end
end
